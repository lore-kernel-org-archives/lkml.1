Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZL1QzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZL1QzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZL1QzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:55:16 -0500
Received: from smtp.witbe.net ([81.88.96.48]:52861 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZL1QzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:55:15 -0500
Date: Mon, 28 Dec 2009 17:53:01 +0100
From: Paul Rolland <rol@as2917.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091228175301.4e89aa65@tux.DEF.witbe.net>
In-Reply-To: <20091228160212.1f70d825@tux.DEF.witbe.net>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091225102731.GA25513@elte.hu>
	<alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
	<alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
	<20091228094444.GG24690@elte.hu>
	<20091228120125.GA10911@elte.hu>
	<20091228160212.1f70d825@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Message from syslogd@tux at Dec 28 16:00:22 ...
>  kernel:CR2: 0000000100000024
> Dec 28 16:00:22 tux kernel: ACPI: WMI: Mapper loaded
> Dec 28 16:00:22 tux kernel: input: Dell WMI hotkeys
> as /devices/virtual/input/input13 Dec 28 16:00:22 tux kernel: BUG: unable
> to handle kernel paging request at 0000000100000024 Dec 28 16:00:22 tux
> kernel: IP: [<ffffffffa0003789>] wmi_install_notify_handler+0x39/0x80
> [wmi] Dec 28 16:00:22 tux kernel: PGD 565f3067 PUD 0 Dec 28 16:00:22 tux
> kernel: Oops: 0000 [#1] SMP Dec 28 16:00:22 tux kernel: last sysfs
> file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq Dec 28
> 16:00:22 tux kernel: CPU 1 Dec 28 16:00:22 tux kernel: Pid: 20215, comm:
> modprobe Not tainted 2.6.33-rc2 #1 0T816J/Vostro 1520 Dec 28 16:00:22 tux
> kernel: RIP: 0010:[<ffffffffa0003789>]  [<ffffffffa0003789>]
> wmi_install_notify_handler+0x39/0x80 [wmi] Dec 28 16:00:22 tux kernel:
> RSP: 0018:ffff88009434bed8  EFLAGS: 00010202 Dec 28 16:00:22 tux kernel:
> RAX: 0000000000000015 RBX: ffffffffa014f0f0 RCX: 000000000000009d Dec 28
> 16:00:22 tux kernel: RDX: 00000000fffffff4 RSI: ffff88009434be98 RDI:
> ffff88009434be8c Dec 28 16:00:22 tux kernel: RBP: ffff88009434bef8 R08:
> ffff88009434be88 R09: 0000000000000010 Dec 28 16:00:22 tux kernel: R10:
> ffff88009434bee0 R11: 0000000000000006 R12: 0000000000000000 Dec 28
> 16:00:22 tux kernel: R13: 0000000002188470 R14: 0000000000000000 R15:
> 0000000000000000 Dec 28 16:00:22 tux kernel: FS:  00007fb6aa7446f0(0000)
> GS:ffff880028300000(0000) knlGS:0000000000000000 Dec 28 16:00:22 tux
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b Dec 28 16:00:22
> tux kernel: CR2: 0000000100000024 CR3: 00000000bd319000 CR4:
> 00000000000406e0 Dec 28 16:00:22 tux kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000 Dec 28 16:00:22 tux kernel: DR3:
> 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 Dec 28
> 16:00:22 tux kernel: Process modprobe (pid: 20215, threadinfo
> ffff88009434a000, task ffff8800a3a0ace0) Dec 28 16:00:22 tux kernel:
> Stack: Dec 28 16:00:22 tux kernel: ffff88009434bef8 00000000fffffff4
> 0000000000000000 ffffffffa0152000 Dec 28 16:00:22 tux kernel: <0>
> ffff88009434bf18 ffffffffa0152142 0000000000000000 0000000000000000 Dec
> 28 16:00:22 tux kernel: <0> ffff88009434bf48 ffffffff810001d7
> 0000000000000000 ffffffffa014f780 Dec 28 16:00:22 tux kernel: Call Trace:
> Dec 28 16:00:22 tux kernel: [<ffffffffa0152000>] ?
> dell_wmi_init+0x0/0x14a [dell_wmi] Dec 28 16:00:22 tux kernel:
> [<ffffffffa0152142>] dell_wmi_init+0x142/0x14a [dell_wmi] Dec 28 16:00:22
> tux kernel: [<ffffffff810001d7>] do_one_initcall+0x37/0x190 Dec 28
> 16:00:22 tux kernel: [<ffffffff81074408>] sys_init_module+0xd8/0x250 Dec
> 28 16:00:22 tux kernel: [<ffffffff810024ab>]
> system_call_fastpath+0x16/0x1b Dec 28 16:00:22 tux kernel: Code: 65 f8 48
> 89 f3 49 89 d4 48 85 f6 74 35 48 85 ff 74 30 48 8d 75 e8 e8 27 fd ff ff
> 48 8b 55 e8 b8 06 00 00 00 48 85 d2 74 09 b0 15 <48> 83 7a 30 00 74 20 48
> 8b 5d f0 4c 8b 65 f8 c9 c3 66 0f 1f 44 Dec 28 16:00:22 tux kernel: RIP
> [<ffffffffa0003789>] wmi_install_notify_handler+0x39/0x80 [wmi] Dec 28
> 16:00:22 tux kernel: RSP <ffff88009434bed8> Dec 28 16:00:22 tux kernel:
> CR2: 0000000100000024 Dec 28 16:00:22 tux kernel: ---[ end trace
> d18b623021a6c139 ]---
> 

Fixed this completely with the following two patches on top of 2.6.33-rc2 :

--- wmi.c.orig  2009-12-28 17:27:15.000000000 +0100
+++ wmi.c       2009-12-28 17:39:01.000000000 +0100
@@ -488,12 +488,13 @@
 {
        struct wmi_block *block;
        acpi_status status;
+       bool err;
 
        if (!guid || !handler)
                return AE_BAD_PARAMETER;
 
-       find_guid(guid, &block);
-       if (!block)
+       err = find_guid(guid, &block);
+       if (!err)
                return AE_NOT_EXIST;
 
        if (block->handler)
@@ -517,12 +518,13 @@
 {
        struct wmi_block *block;
        acpi_status status;
+       bool err;
 
        if (!guid)
                return AE_BAD_PARAMETER;
 
-       find_guid(guid, &block);
-       if (!block)
+       err = find_guid(guid, &block);
+       if (!err)
                return AE_NOT_EXIST;
 
        if (!block->handler)

--- dell-wmi.c.orig     2009-12-28 17:49:09.000000000 +0100
+++ dell-wmi.c  2009-12-28 17:41:36.000000000 +0100
@@ -343,7 +343,7 @@
                printk(KERN_ERR
                        "dell-wmi: Unable to register notify handler - %d\n",
                        err);
-               return err;
+               return -err;
        }
 
        return 0;


Signed-off-by: rol@as2917.net <Paul Rolland>

Paul
