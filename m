Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbXJYUJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbXJYUJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXJYUIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:08:51 -0400
Received: from smtp-out.abv.bg ([194.153.145.80]:46770 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761561AbXJYUHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:07:12 -0400
X-Greylist: delayed 3337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 16:07:11 EDT
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=qXEaSFEN/e0kjjXNPx1XvFZnNqoCyyUzSZ8qK+NIlY5VzpwIXyXBIYE7OnURUWF+t
	gaoNmX7dXF3m1Bl72LlJkqFuFWsp+/z6y8fWCWFnPWxWIMdscGoV0hj4/Nisy4RxZh5
	LHHtzIJbvZFPVEHt7A2C6UNggCymXCBuq7QbF94=
Date: Thu, 25 Oct 2007 22:11:30 +0300 (EEST)
From: Bozhan Boiadzhiev <bozhan@abv.bg>
To: linux-kernel@vger.kernel.org
Message-ID: <1635344761.782961193339490176.JavaMail.nobody@mail53.abv.bg>
Subject: BUG: unable to handle kernel NULL pointer dereference<1>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1251"
Content-Transfer-Encoding: 8bit
X-Mailer: AbvMail 1.0
X-Originating-IP: 87.118.176.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000054
 printing eip:
c025c099
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: tcp_diag inet_diag cls_u32 cls_fw sch_sfq sch_htb xt_mac xt_limit xt_multiport xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nfnetlink xt_MARK iptable_mangle iptable_filter ip_tables x_tables button ac battery ipv6 dm_snapshot dm_mirror dm_mod loop iTCO_wdt pcspkr rtc i2c_i801 i2c_c
ore shpchp pci_hotplug evdev ext3 jbd mbcache ide_cd cdrom generic sd_mod piix ide_core 3w_9xxx ata_generic libata scsi_mod floppy e1000 thermal processor fan
CPU:    1
EIP:    0060:[<c025c099>]    Not tainted VLI
EFLAGS: 00210202   (2.6.22-2-686 #1)
EIP is at netlink_run_queue+0x93/0xd2
eax: 00000000   ebx: f0dafe00   ecx: 00200202   edx: 00200200
esi: 00000000   edi: f1713e08   ebp: f739c400   esp: f1713dec
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process identd (pid: 8104, ti=f1712000 task=c3144580 task.ti=f1712000)
Stack: f8c69921 f739c46c f739c400 0000004c f1713f64 f400b600 f8c6901b 00000001
       f739c400 c025c4c8 0000004c f739c400 c025b48f f415e8c0 00000000 c025c4aa
       00000000 dff59af4 f1713ea0 f4725380 00000000 00000000 f1713e80 00001fa4
Call Trace:
 [<f8c69921>] inet_diag_rcv_msg+0x0/0x4f6 [inet_diag]
 [<f8c6901b>] inet_diag_rcv+0x1b/0x24 [inet_diag]
 [<c025c4c8>] netlink_data_ready+0x12/0x4c
 [<c025b48f>] netlink_sendskb+0x19/0x30
 [<c025c4aa>] netlink_sendmsg+0x267/0x273
 [<c023e7bc>] sock_aio_write+0xf6/0x102
 [<c011c331>] __wake_up+0x32/0x43
 [<c015cb05>] find_extend_vma+0x12/0x49
 [<c0169cf9>] do_sync_write+0xc7/0x10a
 [<c013319d>] autoremove_wake_function+0x0/0x35
 [<c0102f7d>] __switch_to+0xa3/0x126
 [<c016a4f1>] vfs_write+0xbc/0x12a
 [<c016aa68>] sys_write+0x41/0x67
 [<c0103d0e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: af f0 ff ff 83 7e 54 00 75 34 eb 43 31 c9 0f b7 43 06 83 e0 04 09 c8 74 09 89 da 89 f0 e8 dd fc ff ff 89 f2 89 d8 e8 88 f0 ff ff <8b> 56 54 83 fa 0f 77
9c 89 f0 e8 44 80 fe ff ff 0f eb 1c 8b 44
EIP: [<c025c099>] netlink_run_queue+0x93/0xd2 SS:ESP 0068:f1713dec
 at virtual address 00000054
 printing eip:
c025c099
*pde = 00000000
Oops: 0000 [#2]
SMP
Modules linked in: tcp_diag inet_diag cls_u32 cls_fw sch_sfq sch_htb xt_mac xt_limit xt_multiport xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nfnetlink xt_MARK iptable_mangle iptable_filter ip_tables x_tables button ac battery ipv6 dm_snapshot dm_mirror dm_mod loop iTCO_wdt pcspkr rtc i2c_i801 i2c_c
ore shpchp pci_hotplug evdev ext3 jbd mbcache ide_cd cdrom generic sd_mod piix ide_core 3w_9xxx ata_generic libata scsi_mod floppy e1000 thermal processor fan
CPU:    0
EIP:    0060:[<c025c099>]    Not tainted VLI
EFLAGS: 00210202   (2.6.22-2-686 #1)
EIP is at netlink_run_queue+0x93/0xd2
eax: 00000000   ebx: f1af2200   ecx: 00200202   edx: 00200200
esi: 00000000   edi: f170de08   ebp: f739c400   esp: f170ddec
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process identd (pid: 8101, ti=f170c000 task=c3147a50 task.ti=f170c000)
Stack: f8c69921 f739c46c f739c400 0000004c f170df64 f4f20e00 f8c6901b 00000001
       f739c400 c025c4c8 0000004c f739c400 c025b48f f556a240 00000000 c025c4aa
       00000000 dff59af4 f170dea0 f40a1cc0 00000000 00000000 f170de80 00001fa4
Call Trace:
 [<f8c69921>] inet_diag_rcv_msg+0x0/0x4f6 [inet_diag]
 [<f8c6901b>] inet_diag_rcv+0x1b/0x24 [inet_diag]
 [<c025c4c8>] netlink_data_ready+0x12/0x4c
 [<c025b48f>] netlink_sendskb+0x19/0x30
 [<c025c4aa>] netlink_sendmsg+0x267/0x273
 [<c023e7bc>] sock_aio_write+0xf6/0x102
 [<c011c331>] __wake_up+0x32/0x43
 [<c015cb05>] find_extend_vma+0x12/0x49
 [<c0169cf9>] do_sync_write+0xc7/0x10a
 [<c013319d>] autoremove_wake_function+0x0/0x35
 [<c0102f7d>] __switch_to+0xa3/0x126
 [<c016a4f1>] vfs_write+0xbc/0x12a
 [<c016aa68>] sys_write+0x41/0x67
 [<c0103d0e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: af f0 ff ff 83 7e 54 00 75 34 eb 43 31 c9 0f b7 43 06 83 e0 04 09 c8 74 09 89 da 89 f0 e8 dd fc ff ff 89 f2 89 d8 e8 88 f0 ff ff <8b> 56 54 83 fa 0f 77
9c 89 f0 e8 44 80 fe ff ff 0f eb 1c 8b 44
EIP: [<c025c099>] netlink_run_queue+0x93/0xd2 SS:ESP 0068:f170ddec




BUG: unable to handle kernel NULL pointer dereference<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000054
 printing eip:
c025c099
*pde = 00000000
Oops: 0000 [#3]
SMP
Modules linked in: tcp_diag inet_diag cls_u32 cls_fw sch_sfq sch_htb xt_mac xt_limit xt_multiport xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink xt_MARK iptable_mangle iptable_filter ip_tables x_tables button ac battery ipv6 dm_snapshot dm_mirror dm_mod loop iTCO_wdt pcspkr rtc i2c_i801 i2c_core shpchp pci_hotplug evdev ext3 jbd mbcache ide_cd cdrom generic sd_mod piix ide_core 3w_9xxx ata_generic libata scsi_mod floppy e1000 thermal processor fan
CPU:    0
EIP:    0060:[<c025c099>]    Not tainted VLI
EFLAGS: 00210202   (2.6.22-2-686 #1)
EIP is at netlink_run_queue+0x93/0xd2
eax: 00000000   ebx: f5a0e400   ecx: 00200202   edx: 00200200
esi: 00000000   edi: f170fe08   ebp: f739c400   esp: f170fdec
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process identd (pid: 8102, ti=f170e000 task=c3147030 task.ti=f170e000)
Stack: f8c69921 f739c46c f739c400 0000004c f170ff64 f3a46600 f8c6901b 00000001
       f739c400 c025c4c8 0000004c f739c400 c025b48f f633d900 00000000 c025c4aa
       00000000 dff59af4 f170fea0 f6e37800 00000000 00000000 f170fe80 00001fa4
Call Trace:
 [<f8c69921>] inet_diag_rcv_msg+0x0/0x4f6 [inet_diag]
 [<f8c6901b>] inet_diag_rcv+0x1b/0x24 [inet_diag]
 [<c025c4c8>] netlink_data_ready+0x12/0x4c
 [<c025b48f>] netlink_sendskb+0x19/0x30
 [<c025c4aa>] netlink_sendmsg+0x267/0x273
 [<c023e7bc>] sock_aio_write+0xf6/0x102
 [<c011c331>] __wake_up+0x32/0x43
 [<c015cb05>] find_extend_vma+0x12/0x49
 [<c0169cf9>] do_sync_write+0xc7/0x10a
 [<c013319d>] autoremove_wake_function+0x0/0x35
 [<c016a4f1>] vfs_write+0xbc/0x12a
 [<c016aa68>] sys_write+0x41/0x67
 [<c0103d0e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: af f0 ff ff 83 7e 54 00 75 34 eb 43 31 c9 0f b7 43 06 83 e0 04 09 c8 74 09 89 da 89 f0 e8 dd fc ff ff 89 f2 89 d8 e8 88 f0 ff ff <8b> 56 54 83 fa 0f 77 9c 89 f0 e8 44 80 fe ff ff 0f eb 1c 8b 44
EIP: [<c025c099>] netlink_run_queue+0x93/0xd2 SS:ESP 0068:f170fdec
 at virtual address 00000054
 printing eip:
c025c099
*pde = 00000000
Oops: 0000 [#4]
SMP
Modules linked in: tcp_diag inet_diag cls_u32 cls_fw sch_sfq sch_htb xt_mac xt_limit xt_multiport xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink xt_MARK iptable_mangle iptable_filter ip_tables x_tables button ac battery ipv6 dm_snapshot dm_mirror dm_mod loop iTCO_wdt pcspkr rtc i2c_i801 i2c_core shpchp pci_hotplug evdev ext3 jbd mbcache ide_cd cdrom generic sd_mod piix ide_core 3w_9xxx ata_generic libata scsi_mod floppy e1000 thermal processor fan
CPU:    1
EIP:    0060:[<c025c099>]    Not tainted VLI
EFLAGS: 00210202   (2.6.22-2-686 #1)
EIP is at netlink_run_queue+0x93/0xd2
eax: 00000000   ebx: f7315800   ecx: 00200202   edx: 00200200
esi: 00000000   edi: f1711e08   ebp: f739c400   esp: f1711dec
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process identd (pid: 8103, ti=f1710000 task=c3144a90 task.ti=f1710000)
Stack: f8c69921 f739c46c f739c400 0000004c f1711f64 f3bb9600 f8c6901b 00000001
       f739c400 c025c4c8 0000004c f739c400 c025b48f f63495c0 00000000 c025c4aa
       00000000 dff59af4 f1711ea0 f4725500 00000000 00000000 f1711e80 00001fa4
Call Trace:
 [<f8c69921>] inet_diag_rcv_msg+0x0/0x4f6 [inet_diag]
 [<f8c6901b>] inet_diag_rcv+0x1b/0x24 [inet_diag]
 [<c025c4c8>] netlink_data_ready+0x12/0x4c
 [<c025b48f>] netlink_sendskb+0x19/0x30
 [<c025c4aa>] netlink_sendmsg+0x267/0x273
 [<c023e7bc>] sock_aio_write+0xf6/0x102
 [<c011c331>] __wake_up+0x32/0x43
 [<c015cb05>] find_extend_vma+0x12/0x49
 [<c0169cf9>] do_sync_write+0xc7/0x10a
 [<c013319d>] autoremove_wake_function+0x0/0x35
 [<c0102f7d>] __switch_to+0xa3/0x126
 [<c016a4f1>] vfs_write+0xbc/0x12a
 [<c016aa68>] sys_write+0x41/0x67
 [<c0103d0e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: af f0 ff ff 83 7e 54 00 75 34 eb 43 31 c9 0f b7 43 06 83 e0 04 09 c8 74 09 89 da 89 f0 e8 dd fc ff ff 89 f2 89 d8 e8 88 f0 ff ff <8b> 56 54 83 fa 0f 77 9c 89 f0 e8 44 80 fe ff ff 0f eb 1c 8b 44
EIP: [<c025c099>] netlink_run_queue+0x93/0xd2 SS:ESP 0068:f1711dec





-----------------------------------------------------------------
Стани Survivor OnLine! Сподели свое видео или снимки! http://survivor.btv.bg/isurvive/
