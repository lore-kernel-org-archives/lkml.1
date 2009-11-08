Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZKHOf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZKHOf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZKHOf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:35:28 -0500
Received: from lucidpixels.com ([75.144.35.66]:44611 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZKHOf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:35:28 -0500
Date: Sun, 8 Nov 2009 09:35:33 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80()
Message-ID: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Motherboard: Intel DP55KG
BIOS: 3878P (latest as of 11/08/09)

When CPUFREQ is compiled in the kernel:

[    3.374532] cpuidle: using governor ladder
[    3.377935] ------------[ cut here ]------------
[    3.377939] WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80()
[    3.377940] Hardware name:
[    3.377941] Modules linked in:
[    3.377942] Pid: 0, comm: swapper Not tainted 2.6.31.4 #18
[    3.377943] Call Trace:
[    3.377946]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.377947]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.377950]  [<ffffffff810564d4>] ? warn_slowpath_common+0x74/0xd0
[    3.377952]  [<ffffffff81043180>] ? hpet_next_event+0x70/0x80
[    3.377954]  [<ffffffff81076fd6>] ? tick_dev_program_event+0x36/0xb0
[    3.377956]  [<ffffffff810769b9>] ? tick_broadcast_oneshot_control+0x119/0x120
[    3.377957]  [<ffffffff8107617d>] ? tick_notify+0x22d/0x420
[    3.377960]  [<ffffffff8106f737>] ? notifier_call_chain+0x37/0x70
[    3.377961]  [<ffffffff81075a6b>] ? clockevents_notify+0x2b/0x90
[    3.377964]  [<ffffffff812438a8>] ? acpi_idle_enter_bm+0x15f/0x2d3
[    3.377966]  [<ffffffff8124373e>] ? acpi_idle_enter_c1+0xf1/0xfc
[    3.377969]  [<ffffffff812e84ea>] ? cpuidle_idle_call+0xba/0x120
[    3.377972]  [<ffffffff8102b830>] ? cpu_idle+0x60/0xa0
[    3.377975] ---[ end trace 222f8db6d7ba1b9b ]---


[    3.883303] cpufreq-core: trying to register driver acpi-cpufreq
[    3.883305] cpufreq-core: adding CPU 0
[    3.883348] cpufreq-core: initialization failed
[    3.883349] cpufreq-core: adding CPU 1
[    3.883390] cpufreq-core: initialization failed
[    3.883391] cpufreq-core: adding CPU 2
[    3.883432] cpufreq-core: initialization failed
[    3.883433] cpufreq-core: adding CPU 3
[    3.883473] cpufreq-core: initialization failed
[    3.883474] cpufreq-core: adding CPU 4
[    3.883515] cpufreq-core: initialization failed
[    3.883516] cpufreq-core: adding CPU 5
[    3.883556] cpufreq-core: initialization failed
[    3.883557] cpufreq-core: adding CPU 6
[    3.883598] cpufreq-core: initialization failed
[    3.883599] cpufreq-core: adding CPU 7
[    3.883639] cpufreq-core: initialization failed
[    3.883640] cpufreq-core: no CPU initialized for driver acpi-cpufreq

Justin.

