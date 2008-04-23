Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYDWXpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYDWXpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYDWXpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:45:33 -0400
Received: from 83-216-141-215.markhi700.adsl.metronet.co.uk ([83.216.141.215]:43921
	"EHLO mx.hindley.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYDWXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:45:32 -0400
X-Greylist: delayed 1892 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 19:45:31 EDT
Date: Thu, 24 Apr 2008 00:13:55 +0100
From: Mark Hindley <mark@hindley.org.uk>
To: linux-kernel@vger.kernel.org
Subject: oops: 2.6.24.4 [tainted]
Message-ID: <20080423231355.GC30598@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have an old K6 200/430TX system (used for routing and backups) on
which I have been chasing random crashes and reboots for a while.
Normally there is nothing in the logs. They seem to happen under high
load, but are not reproducible reliably.

I have just replaced all the RAM with new, but still got this oops this
evening.

Unfortunately, the kernel is tainted by madwifi. I will change to ath5k
as soon as my card is supported :)

Could someone help me decode this. Is it real or faulty hardware? Let me
know if other info would be useful

Thanks,

Mark

Apr 23 18:33:35 titan kernel: 
Apr 23 18:33:35 titan kernel: Pid: 2231, comm: samhain Tainted: P (2.6.24.4-mtd-mk6 #1)
Apr 23 18:33:35 titan kernel: EIP: 7fc0:[<00000004>] EFLAGS: 00000073 CPU: 0
Apr 23 18:33:35 titan kernel: EIP is at 0x4
Apr 23 18:33:35 titan kernel: EAX: 00000000 EBX: 00000012 ECX: 00008206 EDX: bfe4c488
Apr 23 18:33:35 titan kernel: ESI: bfe492b2 EDI: bfe461fc EBP: bfe49328 ESP: c3d50fec
Apr 23 18:33:35 titan kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 23 18:33:35 titan kernel: Process samhain (pid: 2231, ti=c3d50000 task=c21eea60 task.ti=c3d50000)
Apr 23 18:33:35 titan kernel: Stack: 00210297 bfe461d0 0000007b 00000000 00000000 
Apr 23 18:33:35 titan kernel: Call Trace:
Apr 23 18:33:35 titan kernel:  =======================
Apr 23 18:33:35 titan kernel: Code: <0>iret exception: 0000 [#2] PREEMPT 
Apr 23 18:33:35 titan kernel: Modules linked in: softdog nfs nfsd lockd sunrpc exportfs autofs4 ipv6 act_police sch_ingress cls_u32 sch_sfq sch_cbq via_rhine bitrev crc32 af_packet 3c59x mii bridge llc wlan_wep wlan_scan_ap ath_rate_sample ath_pci wlan ath_hal(P) floppy uhci_hcd ohci_hcd ehci_hcd usbcore ipt_owner ipt_REDIRECT xt_limit ipt_recent xt_state ipt_REJECT ipt_LOG xt_tcpudp ipt_MASQUERADE iptable_filter iptable_nat ip_tables nf_nat x_tables nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nls_iso8859_1 nls_cp437 vfat fat tcp_diag inet_diag genrtc mtdblock phram mtd_blkdevs mtd
Apr 23 18:33:35 titan kernel: 
Apr 23 18:33:35 titan kernel: Pid: 2231, comm: samhain Tainted: P (2.6.24.4-mtd-mk6 #1)
Apr 23 18:33:35 titan kernel: EIP: 5389:[<00000000>] EFLAGS: 00000060 CPU: 0
Apr 23 18:33:35 titan kernel: EIP is at _stext+0x3feff000/0x14
Apr 23 18:33:35 titan kernel: EAX: 00000000 EBX: ffffffd9 ECX: c0000000 EDX: c3d50000
Apr 23 18:33:35 titan kernel: ESI: c3d50fb4 EDI: 0000002b EBP: 00000000 ESP: c3d50eb0
Apr 23 18:33:35 titan kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 23 18:33:35 titan kernel: Process samhain (pid: 2231, ti=c3d50000 task=c21eea60 task.ti=c3d50000)
Apr 23 18:33:35 titan kernel: Stack: 00210046 c02bd115 00000010 c21eec1c 000008b7 c3d50000 c21eea60 c3d50000 
Apr 23 18:33:35 titan kernel:        ffffffff 00000040 c0000000 c3d50fb4 c3d50fb4 00000000 c02bd245 00200206 
Apr 23 18:33:35 titan kernel:        c010555d 00000000 00000020 0000000b 00000001 00000000 c3d50fb4 c0105b04 
Apr 23 18:33:35 titan kernel: Call Trace:
Apr 23 18:33:35 titan kernel:  [die+238/453] die+0xee/0x1c5
Apr 23 18:33:35 titan kernel:  [do_iret_error+0/140] do_iret_error+0x0/0x8c
Apr 23 18:33:35 titan kernel:  [do_iret_error+131/140] do_iret_error+0x83/0x8c
Apr 23 18:33:35 titan kernel:  [restore_nocheck_notrace+14/15] restore_nocheck+0xe/0xf
Apr 23 18:33:35 titan kernel:  [search_exception_tables+20/37] search_exception_tables+0x14/0x25
Apr 23 18:33:35 titan kernel:  [fixup_exception+75/96] fixup_exception+0x4b/0x60
Apr 23 18:33:35 titan kernel:  [do_trap+129/188] do_trap+0x81/0xbc
Apr 23 18:33:35 titan kernel:  [do_stack_segment+0/101] do_stack_segment+0x0/0x65
Apr 23 18:33:35 titan kernel:  [do_stack_segment+95/101] do_stack_segment+0x5f/0x65
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  =======================
Apr 23 18:33:35 titan kernel: Code:  Bad EIP value.
Apr 23 18:33:35 titan kernel: EIP: [<00000000>] _stext+0x3feff000/0x14 SS:ESP 0068:c3d50eb0
Apr 23 18:33:35 titan kernel: ---[ end trace 6820a10c303deb46 ]---
Apr 23 18:33:35 titan kernel: note: samhain[2231] exited with preempt_count 1
Apr 23 18:33:35 titan kernel: BUG: scheduling while atomic: samhain/2231/0x10000002
Apr 23 18:33:35 titan kernel: Pid: 2231, comm: samhain Tainted: P      D 2.6.24.4-mtd-mk6 #1
Apr 23 18:33:35 titan kernel:  [schedule+81/599] schedule+0x51/0x257
Apr 23 18:33:35 titan kernel:  [__cond_resched+19/48] __cond_resched+0x13/0x30
Apr 23 18:33:35 titan kernel:  [cond_resched+35/44] cond_resched+0x23/0x2c
Apr 23 18:33:35 titan kernel:  [unmap_vmas+866/1094] unmap_vmas+0x362/0x446
Apr 23 18:33:35 titan kernel:  [exit_mmap+105/232] exit_mmap+0x69/0xe8
Apr 23 18:33:35 titan kernel:  [mmput+31/124] mmput+0x1f/0x7c
Apr 23 18:33:35 titan kernel:  [do_exit+438/1615] do_exit+0x1b6/0x64f
Apr 23 18:33:35 titan kernel:  [printk+27/31] printk+0x1b/0x1f
Apr 23 18:33:35 titan kernel:  [die+445/453] die+0x1bd/0x1c5
Apr 23 18:33:35 titan kernel:  [do_iret_error+0/140] do_iret_error+0x0/0x8c
Apr 23 18:33:35 titan kernel:  [do_iret_error+131/140] do_iret_error+0x83/0x8c
Apr 23 18:33:35 titan kernel:  [restore_nocheck_notrace+14/15] restore_nocheck+0xe/0xf
Apr 23 18:33:35 titan kernel:  [search_exception_tables+20/37] search_exception_tables+0x14/0x25
Apr 23 18:33:35 titan kernel:  [fixup_exception+75/96] fixup_exception+0x4b/0x60
Apr 23 18:33:35 titan kernel:  [do_trap+129/188] do_trap+0x81/0xbc
Apr 23 18:33:35 titan kernel:  [do_stack_segment+0/101] do_stack_segment+0x0/0x65
Apr 23 18:33:35 titan kernel:  [do_stack_segment+95/101] do_stack_segment+0x5f/0x65
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [show_registers+216/446] show_registers+0xd8/0x1be
Apr 23 18:33:35 titan kernel:  [die+238/453] die+0xee/0x1c5
Apr 23 18:33:35 titan kernel:  [do_iret_error+0/140] do_iret_error+0x0/0x8c
Apr 23 18:33:35 titan kernel:  [do_iret_error+131/140] do_iret_error+0x83/0x8c
Apr 23 18:33:35 titan kernel:  [restore_nocheck_notrace+14/15] restore_nocheck+0xe/0xf
Apr 23 18:33:35 titan kernel:  [search_exception_tables+20/37] search_exception_tables+0x14/0x25
Apr 23 18:33:35 titan kernel:  [fixup_exception+75/96] fixup_exception+0x4b/0x60
Apr 23 18:33:35 titan kernel:  [do_trap+129/188] do_trap+0x81/0xbc
Apr 23 18:33:35 titan kernel:  [do_stack_segment+0/101] do_stack_segment+0x0/0x65
Apr 23 18:33:35 titan kernel:  [do_stack_segment+95/101] do_stack_segment+0x5f/0x65
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  =======================
Apr 23 18:33:35 titan kernel: BUG: scheduling while atomic: samhain/2231/0x10000002
Apr 23 18:33:35 titan kernel: Pid: 2231, comm: samhain Tainted: P      D 2.6.24.4-mtd-mk6 #1
Apr 23 18:33:35 titan kernel:  [schedule+81/599] schedule+0x51/0x257
Apr 23 18:33:35 titan kernel:  [__cond_resched+19/48] __cond_resched+0x13/0x30
Apr 23 18:33:35 titan kernel:  [cond_resched+35/44] cond_resched+0x23/0x2c
Apr 23 18:33:35 titan kernel:  [put_files_struct+100/167] put_files_struct+0x64/0xa7
Apr 23 18:33:35 titan kernel:  [do_exit+461/1615] do_exit+0x1cd/0x64f
Apr 23 18:33:35 titan kernel:  [printk+27/31] printk+0x1b/0x1f
Apr 23 18:33:35 titan kernel:  [die+445/453] die+0x1bd/0x1c5
Apr 23 18:33:35 titan kernel:  [do_iret_error+0/140] do_iret_error+0x0/0x8c
Apr 23 18:33:35 titan kernel:  [do_iret_error+131/140] do_iret_error+0x83/0x8c
Apr 23 18:33:35 titan kernel:  [restore_nocheck_notrace+14/15] restore_nocheck+0xe/0xf
Apr 23 18:33:35 titan kernel:  [search_exception_tables+20/37] search_exception_tables+0x14/0x25
Apr 23 18:33:35 titan kernel:  [fixup_exception+75/96] fixup_exception+0x4b/0x60
Apr 23 18:33:35 titan kernel:  [do_trap+129/188] do_trap+0x81/0xbc
Apr 23 18:33:35 titan kernel:  [do_stack_segment+0/101] do_stack_segment+0x0/0x65
Apr 23 18:33:35 titan kernel:  [do_stack_segment+95/101] do_stack_segment+0x5f/0x65
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [show_registers+216/446] show_registers+0xd8/0x1be
Apr 23 18:33:35 titan kernel:  [die+238/453] die+0xee/0x1c5
Apr 23 18:33:35 titan kernel:  [do_iret_error+0/140] do_iret_error+0x0/0x8c
Apr 23 18:33:35 titan kernel:  [do_iret_error+131/140] do_iret_error+0x83/0x8c
Apr 23 18:33:35 titan kernel:  [restore_nocheck_notrace+14/15] restore_nocheck+0xe/0xf
Apr 23 18:33:35 titan kernel:  [search_exception_tables+20/37] search_exception_tables+0x14/0x25
Apr 23 18:33:35 titan kernel:  [fixup_exception+75/96] fixup_exception+0x4b/0x60
Apr 23 18:33:35 titan kernel:  [do_trap+129/188] do_trap+0x81/0xbc
Apr 23 18:33:35 titan kernel:  [do_stack_segment+0/101] do_stack_segment+0x0/0x65
Apr 23 18:33:35 titan kernel:  [do_stack_segment+95/101] do_stack_segment+0x5f/0x65
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  [error_code+106/112] error_code+0x6a/0x70
Apr 23 18:33:35 titan kernel:  =======================

