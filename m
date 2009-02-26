Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZBZLQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZBZLQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZBZLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:16:12 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:59682 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZBZLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:16:11 -0500
Message-ID: <49A679E8.1010301@krogh.cc>
Date: Thu, 26 Feb 2009 12:15:52 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Booting up 2.6.29-rc6 gave me this one in dmesg...

[   21.136149] ck804xrom ck804xrom_init_one(): Unable to register 
resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
[   21.136258] resource map sanity check conflict: 0xff000000 0xffffffff 
0xff700000 0xffffffff reserved
[   21.136267] ------------[ cut here ]------------
[   21.136269] WARNING: at arch/x86/mm/ioremap.c:208 
__ioremap_caller+0x359/0x390()
[   21.136271] Hardware name: Sun Fire X2200 M2 with Quad Core Processor
[   21.136273] Info: mapping multiple BARs. Your kernel is fine.Modules 
linked in: ck804xrom(+) mtd chipreg pcspkr(+) shpchp button pci_hotplug 
i2c_nforce2 i2c_core map_funcs evdev ext3 jbd mbcache sg sd_mod usbhid 
hid amd74xx sata_nv tg3 ata_generic libphy ehci_hcd libata ohci_hcd 
forcedeth scsi_mod usbcore thermal processor fan thermal_sys fuse
[   21.136289] Pid: 3843, comm: modprobe Not tainted 2.6.29-rc6 #2
[   21.136291] Call Trace:
[   21.136298]  [<ffffffff8023d352>] warn_slowpath+0xf2/0x130
[   21.136301]  [<ffffffff8023d62a>] __call_console_drivers+0x6a/0x90
[   21.136304]  [<ffffffff8023e1fe>] printk+0x4e/0x60
[   21.136306]  [<ffffffff8023e1fe>] printk+0x4e/0x60
[   21.136309]  [<ffffffff8036b520>] match_pci_dev_by_id+0x0/0x60
[   21.136313]  [<ffffffff8024360e>] iomem_map_sanity_check+0xbe/0xd0
[   21.136316]  [<ffffffff80229799>] __ioremap_caller+0x359/0x390
[   21.136320]  [<ffffffffa01eb1f6>] init_ck804xrom+0x1f6/0x62c [ck804xrom]
[   21.136322]  [<ffffffffa01eb1f6>] init_ck804xrom+0x1f6/0x62c [ck804xrom]
[   21.136326]  [<ffffffff80275eac>] tracepoint_update_probe_range+0x1c/0xb0
[   21.136329]  [<ffffffffa01eb000>] init_ck804xrom+0x0/0x62c [ck804xrom]
[   21.136332]  [<ffffffff8020903b>] _stext+0x3b/0x160
[   21.136335]  [<ffffffff80359141>] __up_read+0x21/0xb0
[   21.136340]  [<ffffffff80256495>] 
__blocking_notifier_call_chain+0x65/0x90
[   21.136343]  [<ffffffff80265604>] sys_init_module+0xb4/0x200
[   21.136346]  [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
[   21.136348] ---[ end trace f807e12658961c2d ]---


System is fully operational, but I didnt get it in 2.6.26.8 (most recent 
kernel tried on this hardware).


-- 
Jesper


