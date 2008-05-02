Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbYEBAn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbYEBAn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYEBAnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:43:17 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:40120 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbYEBAnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:43:16 -0400
Message-ID: <003a01c8abed$7ffe4bf0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Subject: modprobe ocfs2_stack_o2cb warning - duplicate filename o2cb in sysfs
Date: Fri, 2 May 2008 02:11:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX18yxxPTu2QX02SPulSbGaMjk4MfGJ94I5VEA85t
	dBcLQBm/6fUtvLvaLPoEBiHdqJpn6S4s8H/IVugMshCbAVPMVl
	mFm2QtL9I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git17 on vmware - just modprobe ocfs2_stack_o2cb after boot

May  2 02:10:46 opensuse103 kernel: OCFS2 Node Manager 1.5.0
May  2 02:10:47 opensuse103 kernel: sysfs: duplicate filename 'o2cb' can not 
be created
May  2 02:10:47 opensuse103 kernel: ------------[ cut here ]------------
May  2 02:10:47 opensuse103 kernel: WARNING: at fs/sysfs/dir.c:425 
sysfs_add_one+0x31/0x7a()
May  2 02:10:47 opensuse103 kernel: Modules linked in: ocfs2_nodemanager(+) 
configfs ocfs2_stackglue iptable_filter ip_tables ip6table_filter ip6_tables 
x_tables ipv6 af_packet microcode firmware_class fuse loop dm_mod ide_cd_mod 
cdrom pata_acpi ata_piix ahci ata_generic libata dock ide_pci_generic 
parport_pc pcnet32 i2c_piix4 shpchp rtc_cmos piix intel_agp container 
parport mii ac button rtc_core agpgart i2c_core rtc_lib ide_core pci_hotplug 
uhci_hcd usbcore edd ext3 mbcache jbd fan mptsas scsi_transport_sas mptfc 
scsi_transport_fc scsi_tgt mptspi mptscsih mptbase scsi_transport_spi sd_mod 
sg scsi_mod thermal processor [last unloaded: pcips2]
May  2 02:10:47 opensuse103 kernel: Pid: 2651, comm: modprobe Not tainted 
2.6.25-git17-default #1
May  2 02:10:47 opensuse103 kernel:  [<c0121576>] warn_on_slowpath+0x40/0x67
May  2 02:10:47 opensuse103 kernel:  [<c01258e9>] irq_exit+0x53/0x6a
May  2 02:10:47 opensuse103 kernel:  [<c011142d>] 
smp_apic_timer_interrupt+0x6b/0x76
May  2 02:10:47 opensuse103 kernel:  [<c0105a18>] 
apic_timer_interrupt+0x28/0x30
May  2 02:10:47 opensuse103 kernel:  [<c0121e51>] vprintk+0x2b9/0x2cd
May  2 02:10:47 opensuse103 kernel:  [<c01cbb5c>] 
ida_get_new_above+0xe3/0x163
May  2 02:10:47 opensuse103 kernel:  [<c017e2b0>] find_inode+0x1b/0x56
May  2 02:10:47 opensuse103 kernel:  [<c01a662f>] sysfs_ilookup_test+0x0/0xd
May  2 02:10:47 opensuse103 kernel:  [<c017e395>] ifind+0x22/0x73
May  2 02:10:47 opensuse103 kernel:  [<c017e3a3>] ifind+0x30/0x73
May  2 02:10:47 opensuse103 kernel:  [<c0121e79>] printk+0x14/0x18
May  2 02:10:47 opensuse103 kernel:  [<c01a6865>] sysfs_add_one+0x31/0x7a
May  2 02:10:47 opensuse103 kernel:  [<c01a73ea>] 
sysfs_create_link+0x90/0xde
May  2 02:10:47 opensuse103 kernel:  [<d0c1719c>] o2cb_sys_init+0x2c/0x68 
[ocfs2_nodemanager]
May  2 02:10:47 opensuse103 kernel:  [<d08f508c>] init_o2nm+0x8c/0xb4 
[ocfs2_nodemanager]
May  2 02:10:47 opensuse103 kernel:  [<c013db4c>] 
sys_init_module+0x1694/0x17a7
May  2 02:10:47 opensuse103 kernel:  [<c01ceb32>] simple_strtoull+0x0/0xec
May  2 02:10:47 opensuse103 kernel:  [<c01079de>] sys_mmap2+0x62/0x77
May  2 02:10:47 opensuse103 kernel:  [<c010491f>] 
sysenter_past_esp+0x78/0xb9
May  2 02:10:47 opensuse103 kernel:  =======================
May  2 02:10:47 opensuse103 kernel: ---[ end trace 77c3881ff959c2ac ]---
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol mlog_and_bits
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol o2nm_this_node
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_check_node_heartbeating
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol mlog_not_bits
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_check_local_node_heartbeating
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_setup_callback
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2net_send_message_vec
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_fill_node_map
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2net_unregister_handler_list
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2net_send_message
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2net_register_handler
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_register_callback
May  2 02:10:47 opensuse103 kernel: ocfs2_dlm: Unknown symbol 
o2hb_unregister_callback
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_print_one_lock
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
mlog_and_bits
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
o2nm_this_node
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
mlog_not_bits
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol dlmlock
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
o2nm_get_hb_ctl_path
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
o2hb_check_local_node_heartbeating
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_unregister_eviction_cb
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_unregister_domain
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_register_domain
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_register_eviction_cb
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlm_setup_eviction_cb
May  2 02:10:47 opensuse103 kernel: ocfs2_stack_o2cb: Unknown symbol 
dlmunlock




