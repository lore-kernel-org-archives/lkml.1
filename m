Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZAYWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZAYWwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZAYWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:52:06 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53247 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZAYWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:52:04 -0500
Date: Sun, 25 Jan 2009 14:52:05 -0800
From: Mike Kravetz <kravetz@us.ibm.com>
To: Jon Masters <jcm@redhat.com>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RT] [RFC] simple SMI detector
Message-ID: <20090125225205.GA3783@monkey.beaverton.ibm.com>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 05:55:12PM -0500, Jon Masters wrote:
> This patch adds the module smi_detector under drivers/misc
> 
> Code from Jon Masters with small changes from Luis Goncalves and
> documentation from Clark Williams.

Good work Jon.  I think something like this will be helpful.

Any reason why you could not do SMI detection in user level code running
at the highest RT priority?  If something is running at the highest RT
priority, it should not be preempted by anything.  Right?  In the past,
we discoved discovered periodic SMIs on some hardware platforms by running
a user level process in an infinite loop sampling the clock and reporting
unexpected delays.  Of course, this does hog an entire CPU.

-- 
Mike
