Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZBFTlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZBFTlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZBFTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:40:54 -0500
Received: from www.tglx.de ([62.245.132.106]:52295 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZBFTkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:40:53 -0500
Date: Fri, 6 Feb 2009 20:40:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ben Greear <greearb@candelatech.com>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: PATCH: Allow user to force 'tsc' to be treated as stable.
In-Reply-To: <498C78C9.5090405@candelatech.com>
Message-ID: <alpine.LFD.2.00.0902062040000.22800@localhost.localdomain>
References: <498B42C5.7010905@candelatech.com> <alpine.LRH.1.10.0902061531560.22097@twin.jikos.cz> <498C78C9.5090405@candelatech.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Ben Greear wrote:

> Jiri Kosina wrote:
> > On Thu, 5 Feb 2009, Ben Greear wrote:
> > 
> > > Allow user to force TSC as stable clock-source. Works around BIOS issues
> > > in the FWA-7304 (Via CN700 chipset) system, and possibly others.
> > 
> > How do you know that the TSC is stable on such system? What was the reason
> > for kernel marking it unstable?
> 
> I've used it for a timing source in my own modules and it has
> worked well.  It could still be broken in some way, but if so,
> I'm not sure how to detect it.  Ingo sent me a program to test
> the tsc, and at least for short runs, it showed no problem.
> 
> Another person suggested the system might think it is unstable
> because I have ACPI disabled in my BIOS and that might cause
> the kernel not to have a 'PM timer' that it uses to check the
> tsc?
> 
> Other than that, I have no idea why the kernel thinks the tsc
> is unstable.

Can you please provide the dmesg output, so I can see in which context
this happens.

Thanks,

	tglx
