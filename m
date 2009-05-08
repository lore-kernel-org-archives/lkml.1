Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZEHGqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZEHGqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZEHGqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:46:09 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:3789 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZEHGqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:46:08 -0400
Message-ID: <4A03D501.7050803@krogh.cc>
Date: Fri, 08 May 2009 08:45:21 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.21
References: <20090323221017.GC11563@kroah.com>
In-Reply-To: <20090323221017.GC11563@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I'm announcing the release of the 2.6.27.21 kernel.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.27.20 and 2.6.27.21


Today i got this oops on a 2.6.27.6 that has been up (and working for 
212 days). I didnt seem to find anyting in the git log that matches 
perfectly.

May  7 23:22:29 svin kernel: [14713794.603459] Modules linked in: 
af_packet nls_cp437 isofs nfsd auth_rpcgss exportfs autofs4 nfs lockd 
sunrpc ipv6 bonding iptable_filter ip_tables x_tables parport_pc
lp parport loop cfi_cmdset_0001 cfi_util jedec_probe cfi_probe gen_probe 
i2c_nforce2 ck804xrom mtd button chipreg i2c_core pcspkr shpchp psmouse 
pci_hotplug map_funcs serio_raw joydev evdev ext3 jbd mb
cache ide_cd_mod cdrom sg sd_mod ata_generic libata usbhid hid dock 
mptsas mptscsih mptbase qla2xxx scsi_transport_sas scsi_transport_fc 
ohci_hcd amd74xx ehci_hcd e1000 scsi_mod ide_core usbcore dm_mir
ror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
May  7 23:22:29 svin kernel: [14713794.603459] CPU 31:
May  7 23:22:29 svin kernel: [14713794.603459] Modules linked in: 
af_packet nls_cp437 isofs nfsd auth_rpcgss exportfs autofs4 nfs lockd 
sunrpc ipv6 bonding iptable_filter ip_tables x_tables parport_pc lp 
parport loop cfi_cmdset_0001 cfi_util jedec_probe cfi_probe gen_probe 
i2c_nforce2 ck804xrom mtd button chipreg i2c_core pcspkr shpchp psmouse 
pci_hotplug map_funcs serio_raw joydev evdev ext3 jbd mbcache ide_cd_mod 
cdrom sg sd_mod ata_generic libata usbhid hid dock mptsas mptscsih 
mptbase qla2xxx scsi_transport_sas scsi_transport_fc ohci_hcd amd74xx 
ehci_hcd e1000 scsi_mod ide_core usbcore dm_mirror dm_log dm_snapshot 
dm_mod thermal processor fan thermal_sys fuse
May  7 23:22:29 svin kernel: [14713794.603459] Pid: 130, comm: events/31 
Not tainted 2.6.27.6 #2
May  7 23:22:29 svin kernel: [14713794.603459] RIP: 
0010:[<ffffffff8025949b>]  [<ffffffff8025949b>] csd_flag_wait+0xb/0x10
May  7 23:22:29 svin kernel: [14713794.603459] RSP: 
0018:ffff88021f3d7d78  EFLAGS: 00000202
May  7 23:22:29 svin kernel: [14713794.603459] RAX: 0000000000000020 
RBX: 000000000000001f RCX: 0000000000000020
May  7 23:22:29 svin kernel: [14713794.603459] RDX: 0000000000000020 
RSI: 0000000000000020 RDI: ffff8800adfd4900
May  7 23:22:29 svin kernel: [14713794.603459] RBP: 0000000000000286 
R08: 0000000000000000 R09: ffff88021f3d7cf0
May  7 23:22:29 svin kernel: [14713794.603459] R10: 0000000000000000 
R11: 00000000ffffffff R12: 000000028022b9bf
May  7 23:22:29 svin kernel: [14713794.603459] R13: ffffffff803370aa 
R14: ffff88021f3d7e70 R15: ffff880e272365b8
May  7 23:22:29 svin kernel: [14713794.603459] FS: 
00007f656f4266e0(0000) GS:ffff88101f013b00(0000) knlGS:00000000f7e5eb60
May  7 23:22:29 svin kernel: [14713794.603459] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
May  7 23:22:29 svin kernel: [14713794.603459] CR2: 0000000000620058 
CR3: 0000000000201000 CR4: 00000000000006e0
May  7 23:22:29 svin kernel: [14713794.603459] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
May  7 23:22:29 svin kernel: [14713794.603459] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
May  7 23:22:29 svin kernel: [14713794.603459]
May  7 23:22:29 svin kernel: [14713794.603459] Call Trace:
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8025983a>] ? 
smp_call_function_mask+0x13a/0x230
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8045925f>] ? 
thread_return+0x3a/0x5eb
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80241a84>] ? 
lock_timer_base+0x34/0x70
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff802174a0>] ? 
mcheck_timer+0x0/0x80
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80217d40>] ? 
mcheck_check_cpu+0x0/0x40
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8023ca9d>] ? 
on_each_cpu+0x1d/0x40
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff802174b4>] ? 
mcheck_timer+0x14/0x80
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80248d3e>] ? 
run_workqueue+0xbe/0x150
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80249770>] ? 
worker_thread+0x0/0x100
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80249770>] ? 
worker_thread+0x0/0x100
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8024980f>] ? 
worker_thread+0x9f/0x100
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8024c9c0>] ? 
autoremove_wake_function+0x0/0x30
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80249770>] ? 
worker_thread+0x0/0x100
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff80249770>] ? 
worker_thread+0x0/0x100
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8024c58b>] ? 
kthread+0x4b/0x80
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8020d1b9>] ? 
child_rip+0xa/0x11
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8024c540>] ? 
kthread+0x0/0x80
May  7 23:22:29 svin kernel: [14713794.603459]  [<ffffffff8020d1af>] ? 
child_rip+0x0/0x11
May  7 23:22:29 svin kernel: [14713794.603459]


-- 
Jesper
