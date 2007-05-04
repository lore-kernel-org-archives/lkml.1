Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXEDHm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXEDHm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXEDHm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:42:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38847 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792AbXEDHm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:42:56 -0400
Date: Fri, 4 May 2007 09:42:19 +0200 (MEST)
Message-Id: <200705040742.l447gJPR027148@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: johnstul@us.ibm.com, mikpe@it.uu.se
Subject: Re: Fw: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
Cc: ak@suse.de, len.brown@intel.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 19:38:50 -0700, john stultz wrote:
> > 	So that slow acpi_pm on x86_64 seems to be connected w/ the idle loop.
> > I'm guessing the chipset halts the ACPI PM in lower C states. Do you
> > have any guesses as to what might differ between x86_64 and i386 ACPI
> > idle loops? Or might this be something different in what the BIOS
> > exports in x86_64 mode or i386 mode?
> 
> Mikael,
> 	Just trying to dig a bit more through the acpi_processor_idle code.
> Could you run "cat /proc/acpi/processor/CPU1/power" and reply w/ the
> output?

Here's that file with the x86-64 kernel:

active state:            C2
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 20000 usec
states:
    C1:                  type[C1] promotion[C2] demotion[--] latency[000] usage[00107840] duration[00000000000000000000]
   *C2:                  type[C2] promotion[--] demotion[C1] latency[010] usage[-1987043693] duration[00000000003044809185]

/Mikael
