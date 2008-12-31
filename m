Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYLaGA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYLaGA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 01:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYLaGAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 01:00:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55706 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYLaGAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 01:00:14 -0500
Date: Wed, 31 Dec 2008 01:00:10 -0500
From: Dave Jones <davej@redhat.com>
To: pl ice <telent997@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why kernel make obj file with debug info ?
Message-ID: <20081231060010.GA30169@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	pl ice <telent997@gmail.com>, linux-kernel@vger.kernel.org
References: <41d311580812291817w7a9b77b5k8dc46d3657985476@mail.gmail.com> <41d311580812302130y659e1a2p451633d8224200bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41d311580812302130y659e1a2p451633d8224200bb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 01:30:32PM +0800, pl ice wrote:
 > Hi ,
 >        I found kernel use Kbuild to make obj-file,and I objdumped
 >  these obj file and found they all had section .debug. I think they
 >  will make building kernel use much more time.why these
 >  obj file compile to debug version?

Because you have CONFIG_DEBUG_INFO set.

	Dave

-- 
http://www.codemonkey.org.uk
