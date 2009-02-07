Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZBGDBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZBGDBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBGDBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:01:04 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:46908 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZBGDBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:01:03 -0500
Date: Fri, 06 Feb 2009 22:00:54 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
In-reply-to: <20090206193121.GA32634@elte.hu>
Message-id: <alpine.LFD.2.00.0902062157490.26256@localhost.localdomain>
References: <498B421D.9090609@candelatech.com> <20090206193121.GA32634@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Without this override, performance drops by around 15% on
> > network throughput tests on this system.
> 
> The question is, _why_ does network performance drop?
>
> Do you have a before/after pair of /proc/interrupts output
> perhaps? Does the layout of IRQs change?
>
> The system is not SMP - so only something about UP-IOAPIC can
> be helpful to performance here - or some unknown effect.

I presume it is IOAPIC (good) vs PIC (bad), for the 
patch that provoked this regression was one that caused
the MPS table to be disabled.  (the problem with that patch
was that it was effective not just in ACPI mode, but in acpi=off mode)

The other un-answered question is why the system under test
has ACPI disabled in the BIOS when it did not ship that
way from the manufacturer.

cheers,
-Len
Intel Open Source Technology Center
