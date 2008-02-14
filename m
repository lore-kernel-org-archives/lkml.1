Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYBNGhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYBNGhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYBNGgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:36:52 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57351 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbYBNGgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:36:51 -0500
Date: Thu, 14 Feb 2008 12:06:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Chris Snook <csnook@redhat.com>, lenb@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 panics on boot
Message-ID: <20080214063631.GD17151@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080213170310.GC19570@linux.vnet.ibm.com> <47B3322A.2030607@redhat.com> <20080214062033.GB17151@linux.vnet.ibm.com> <86802c440802132232g79fe5eaew3f86e412eeff41a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802132232g79fe5eaew3f86e412eeff41a9@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:32:02PM -0800, Yinghai Lu wrote:
> On Wed, Feb 13, 2008 at 10:20 PM, Dhaval Giani
> <dhaval@linux.vnet.ibm.com> wrote:
> > On Wed, Feb 13, 2008 at 01:08:42PM -0500, Chris Snook wrote:
> >  > Dhaval Giani wrote:
> >  >> I am getting the following oops on bootup on 2.6.25-rc1
> >  > ...
> >  >> I am booting using kexec with maxcpus=1. It does not have any problems
> >  >> with maxcpus=2 or higher.
> >  >
> >  > Sounds like another (the same?) kexec cpu numbering bug.  Can you post/link
> >  > the entire dmesg from both a cold boot and a kexec boot so we can compare?
> >  >
> >
> >  Don't think its a kexec bug. Get the same on cold boot. dmesg from kexec boot.
> 
> how about without "crashkernel=64M@16M nmi_watchdog=2"
> 
> also does intel cpu support nmi_watchdog=2?
> 

Yes it does. I've used it to get some useful debug information. I will try
that out.

> YH

-- 
regards,
Dhaval
