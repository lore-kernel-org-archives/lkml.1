Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZL1PEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZL1PEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZL1PEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:04:40 -0500
Received: from smtp.witbe.net ([81.88.96.48]:35658 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZL1PEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:04:39 -0500
Date: Mon, 28 Dec 2009 16:02:12 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091228160212.1f70d825@tux.DEF.witbe.net>
In-Reply-To: <20091228120125.GA10911@elte.hu>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091225102731.GA25513@elte.hu>
	<alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
	<alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
	<20091228094444.GG24690@elte.hu>
	<20091228120125.GA10911@elte.hu>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 28 Dec 2009 13:01:25 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> (Note that the system does not have this hardware, and that it's booted
> with the driver built-in. So the relevant codepath should be very simple.
> Config attached.)
> 
> 	Ingo
> 
> [   27.447053] initcall compal_init+0x0/0xf7 returned -19 after 3 usecs
> [   27.453409] calling  dell_wmi_init+0x0/0x129 @ 1
> [   27.458255] PM: Adding info for No Bus:input3
> [   27.462676] input: Dell WMI hotkeys as /class/input/input3
> [   27.468179] BUG: unable to handle kernel NULL pointer dereference at
> 00000014 [   27.472165] IP: [<c1f26aa8>]
> wmi_install_notify_handler+0x28/0x80 [   27.472165] *pde = 00000000 
> [   27.472165] Oops: 0000 [#1] PREEMPT SMP 
> [   27.472165] last sysfs file: 
> [   27.472165] 
> [   27.472165] Pid: 1, comm: swapper Not tainted
> 2.6.33-rc2-tip-00212-g3c2365e-dirty #3297 A8N-E/System Product Name
> [   27.472165] EIP: 0060:[<c1f26aa8>] EFLAGS: 00010282 CPU: 0
> [   27.472165] EIP is at wmi_install_notify_handler+0x28/0x80
> [   27.472165] EAX: fffffff4 EBX: c1f1e200 ECX: 22b612b0 EDX: c2b2d1e0
> [   27.472165] ESI: 00000000 EDI: 00000001 EBP: f64b3f84 ESP: f64b3f78
> [   27.472165]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   27.472165] Process swapper (pid: 1, ti=f64b3000 task=f64d0000
> task.ti=f64b3000) [   27.472165] Stack: [   27.472165]  fffffff4 00000000
> 00000006 f64b3f98 c28d70d7 64a0689d 00000006 64a0689d [   27.472165] <0>
> f64b3fc4 c100112b c255aa54 c28d6fb6 00000001 00000003 00000000 c28d6fb6
> [   27.472165] <0> c294a50c c2882310 00000000 f64b3fd0 c28822fd c29493e8
> f64b3fe4 c2882392 [   27.472165] Call Trace: [   27.472165]
> [<c28d70d7>] ? dell_wmi_init+0x121/0x129 [   27.472165]  [<c100112b>] ?
> do_one_initcall+0x2b/0x1c0 [   27.472165]  [<c28d6fb6>] ?
> dell_wmi_init+0x0/0x129 [   27.472165]  [<c28d6fb6>] ?
> dell_wmi_init+0x0/0x129 [   27.472165]  [<c2882310>] ?
> kernel_init+0x0/0xc9 [   27.472165]  [<c28822fd>] ?
> do_basic_setup+0x44/0x57 [   27.472165]  [<c2882392>] ?
> kernel_init+0x82/0xc9 [   27.472165]  [<c1039816>] ?
> kernel_thread_helper+0x6/0x10 [   27.472165] Code: 00 00 00 55 89 e5 56
> 53 83 ec 04 0f 1f 44 00 00 89 d3 89 ce 85 c0 74 2b 85 d2 74 27 8d 55 f4
> e8 2f fd ff ff 8b 45 f4 85 c0 74 48 <8b> 50 20 85 d2 74 21 b8 15 00 00 00
> 59 5b 5e 5d c3 8d b4 26 00 [   27.472165] EIP: [<c1f26aa8>]
> wmi_install_notify_handler+0x28/0x80 SS:ESP 0068:f64b3f78 [   27.472165]
> CR2: 0000000000000014 [   27.638896] ---[ end trace 7a45c2b3ab0f183e ]---
> [   27.643524] Kernel panic - not syncing: Fatal exception [   27.648758]
> Pid: 1, comm: swapper Tainted: G      D
> 2.6.33-rc2-tip-00212-g3c2365e-dirty #3297 [   27.657546] Call Trace:
> [   27.659997]  [<c2170a4a>] ? printk+0x1d/0x1f [   27.664281]
> [<c217097f>] panic+0x52/0x100 [   27.668390]  [<c103ce33>]
> oops_end+0xb3/0xc0 [   27.672673]  [<c1064d74>] no_context+0xb4/0xd0
> [   27.677124]  [<c1064e27>] __bad_area_nosemaphore+0x97/0x140
> [   27.682706]  [<c1082437>] ? vprintk+0x297/0x420 [   27.687248]
> [<c1064ee7>] bad_area_nosemaphore+0x17/0x20 [   27.692570]  [<c10652c6>]
> do_page_fault+0x296/0x350 [   27.697460]  [<c1f1e200>] ?
> dell_wmi_notify+0x0/0x1c0 [   27.702518]  [<c1065030>] ?
> do_page_fault+0x0/0x350 [   27.707408]  [<c2173a16>] error_code+0x66/0x70
> [   27.711863]  [<c1f1e200>] ? dell_wmi_notify+0x0/0x1c0
> [   27.716924]  [<c1065030>] ? do_page_fault+0x0/0x350
> [   27.721810]  [<c1f26aa8>] ? wmi_install_notify_handler+0x28/0x80
> [   27.727827]  [<c28d70d7>] dell_wmi_init+0x121/0x129
> [   27.732713]  [<c100112b>] do_one_initcall+0x2b/0x1c0
> [   27.737688]  [<c28d6fb6>] ? dell_wmi_init+0x0/0x129
> [   27.742576]  [<c28d6fb6>] ? dell_wmi_init+0x0/0x129
> [   27.747465]  [<c2882310>] ? kernel_init+0x0/0xc9
> [   27.752094]  [<c28822fd>] do_basic_setup+0x44/0x57
> [   27.756896]  [<c2882392>] kernel_init+0x82/0xc9
> [   27.761436]  [<c1039816>] kernel_thread_helper+0x6/0x10

Looks like it is very similar to what I have when I run :
modprobe dell-wmi
on my Dell laptop (Vostro 1520).

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:Oops: 0000 [#1] SMP 

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:Stack:

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:Call Trace:

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:Code: 65 f8 48 89 f3 49 89 d4 48 85 f6 74 35 48 85 ff 74 30 48 8d 75 e8 e8 27 fd ff ff 48 8b 55 e8 b8 06 00 00 00 48 85 d2 74 09 b0 15 <48> 83 7a 30 00 74 20 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 0f 1f 44 

Message from syslogd@tux at Dec 28 16:00:22 ...
 kernel:CR2: 0000000100000024
Dec 28 16:00:22 tux kernel: ACPI: WMI: Mapper loaded
Dec 28 16:00:22 tux kernel: input: Dell WMI hotkeys as /devices/virtual/input/input13
Dec 28 16:00:22 tux kernel: BUG: unable to handle kernel paging request at 0000000100000024
Dec 28 16:00:22 tux kernel: IP: [<ffffffffa0003789>] wmi_install_notify_handler+0x39/0x80 [wmi]
Dec 28 16:00:22 tux kernel: PGD 565f3067 PUD 0 
Dec 28 16:00:22 tux kernel: Oops: 0000 [#1] SMP 
Dec 28 16:00:22 tux kernel: last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Dec 28 16:00:22 tux kernel: CPU 1 
Dec 28 16:00:22 tux kernel: Pid: 20215, comm: modprobe Not tainted 2.6.33-rc2 #1 0T816J/Vostro 1520
Dec 28 16:00:22 tux kernel: RIP: 0010:[<ffffffffa0003789>]  [<ffffffffa0003789>] wmi_install_notify_handler+0x39/0x80 [wmi]
Dec 28 16:00:22 tux kernel: RSP: 0018:ffff88009434bed8  EFLAGS: 00010202
Dec 28 16:00:22 tux kernel: RAX: 0000000000000015 RBX: ffffffffa014f0f0 RCX: 000000000000009d
Dec 28 16:00:22 tux kernel: RDX: 00000000fffffff4 RSI: ffff88009434be98 RDI: ffff88009434be8c
Dec 28 16:00:22 tux kernel: RBP: ffff88009434bef8 R08: ffff88009434be88 R09: 0000000000000010
Dec 28 16:00:22 tux kernel: R10: ffff88009434bee0 R11: 0000000000000006 R12: 0000000000000000
Dec 28 16:00:22 tux kernel: R13: 0000000002188470 R14: 0000000000000000 R15: 0000000000000000
Dec 28 16:00:22 tux kernel: FS:  00007fb6aa7446f0(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
Dec 28 16:00:22 tux kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 28 16:00:22 tux kernel: CR2: 0000000100000024 CR3: 00000000bd319000 CR4: 00000000000406e0
Dec 28 16:00:22 tux kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 28 16:00:22 tux kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 28 16:00:22 tux kernel: Process modprobe (pid: 20215, threadinfo ffff88009434a000, task ffff8800a3a0ace0)
Dec 28 16:00:22 tux kernel: Stack:
Dec 28 16:00:22 tux kernel: ffff88009434bef8 00000000fffffff4 0000000000000000 ffffffffa0152000
Dec 28 16:00:22 tux kernel: <0> ffff88009434bf18 ffffffffa0152142 0000000000000000 0000000000000000
Dec 28 16:00:22 tux kernel: <0> ffff88009434bf48 ffffffff810001d7 0000000000000000 ffffffffa014f780
Dec 28 16:00:22 tux kernel: Call Trace:
Dec 28 16:00:22 tux kernel: [<ffffffffa0152000>] ? dell_wmi_init+0x0/0x14a [dell_wmi]
Dec 28 16:00:22 tux kernel: [<ffffffffa0152142>] dell_wmi_init+0x142/0x14a [dell_wmi]
Dec 28 16:00:22 tux kernel: [<ffffffff810001d7>] do_one_initcall+0x37/0x190
Dec 28 16:00:22 tux kernel: [<ffffffff81074408>] sys_init_module+0xd8/0x250
Dec 28 16:00:22 tux kernel: [<ffffffff810024ab>] system_call_fastpath+0x16/0x1b
Dec 28 16:00:22 tux kernel: Code: 65 f8 48 89 f3 49 89 d4 48 85 f6 74 35 48 85 ff 74 30 48 8d 75 e8 e8 27 fd ff ff 48 8b 55 e8 b8 06 00 00 00 48 85 d2 74 09 b0 15 <48> 83 7a 30 00 74 20 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 0f 1f 44 
Dec 28 16:00:22 tux kernel: RIP  [<ffffffffa0003789>] wmi_install_notify_handler+0x39/0x80 [wmi]
Dec 28 16:00:22 tux kernel: RSP <ffff88009434bed8>
Dec 28 16:00:22 tux kernel: CR2: 0000000100000024
Dec 28 16:00:22 tux kernel: ---[ end trace d18b623021a6c139 ]---


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE
LinkedIn : http://www.linkedin.com/in/paulrolland

This is dedicated to all the ones who want to control Internet, its
content or its usage :

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 


