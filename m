Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZKLOKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZKLOKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZKLOKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:10:05 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38190 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZKLOKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:10:05 -0500
Date: Thu, 12 Nov 2009 14:10:08 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roel Kluin <roel.kluin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
Message-ID: <20091112141008.GK9335@shadowen.org>
References: <4AFB2C0B.50605@gmail.com>
 <20091111134730.a0da9e38.akpm@linux-foundation.org>
 <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com>
 <20091112134554.GA30272@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112134554.GA30272@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 02:45:54PM +0100, Ingo Molnar wrote:

> So i'd suggest to make this a default-enabled check. (default disabled 
> checks are used only by a small minority) For a _long_ time has this 
> been the kernel standard.

Andrew, I've put a dirty hack in to see how well it stands up against
your incoming flow.  This is in the version at the URL below (it may
take a bit to mirror out):

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
