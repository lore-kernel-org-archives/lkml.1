Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXCVOCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXCVOCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbXCVOCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:02:47 -0400
Received: from www.osadl.org ([213.239.205.134]:55277 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932837AbXCVOCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:02:46 -0400
Subject: Re: 2.6.21-rc[123] regression with NOAPIC
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070322134238.GY752@stusta.de>
References: <4601573A.8070602@madrabbit.org>
	 <20070322134238.GY752@stusta.de>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 15:10:03 +0100
Message-Id: <1174572603.10840.162.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 14:42 +0100, Adrian Bunk wrote:
> > Starting with head as of yesterday and reverting two commits (that are
> > duplicates of each other -- the same commit came into Linus's tree via
> > two different paths) 'fixes' the problem for me. I'll let those with the
> > big brains decide just why.
> > 
> > The two commits are 5c95d3f5783ab184f64b7848f0a871352c35c3cf and
> > 3434933b17fa64adddf83059603c61296f6e1ee2 . The net reverse diff of those
> > two is below.
> >...
> 
> Thanks for tracking it down.
> 
> It's quite possible that these commits trigger your problem.
> 
> Does it work if you do _not_ revert the commits, and instead replace in
> drivers/acpi/processor_idle.c the
>   #ifdef ARCH_APICTIMER_STOPS_ON_C3
> with an
>   #if 0
> ?

Then NOAPIC probably works again, but booting w/o NOAPIC fails.

	tglx


