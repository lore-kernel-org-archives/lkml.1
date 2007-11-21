Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbXKUDp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbXKUDp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXKUDpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:45:16 -0500
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:2142 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXKUDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:45:14 -0500
Date: Wed, 21 Nov 2007 04:45:10 +0100 (CET)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: null pointer dereference during restart autofs (was: Linux 2.6.22.12)
In-Reply-To: <20071105180736.GA28562@kroah.com>
Message-ID: <Pine.BSO.4.63.0711210442290.22340@rudy.mif.pg.gda.pl>
References: <20071105180736.GA28562@kroah.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-137207086-1195616710=:22340"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-137207086-1195616710=:22340
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT


BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
  printing eip:
c047102c
*pdpt = 0000000024e2c001
*pde = 0000000000000000
Oops: 0002 [#1]
SMP
Modules linked in: nfsd exportfs iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 ipt_LOG ipt_connlimit nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables nfs lockd nfs_acl ipv6 autofs4 sunrpc binfmt_misc quota_v2 dm_mirror dm_mod video sbs button dock battery ac parport_pc lp parport floppy nvram sr_mod cdrom joydev ata_generic sg e752x_edac edac_mc ata_piix pata_sil680 ehci_hcd libata iTCO_wdt iTCO_vendor_support e1000 uhci_hcd rtc_cmos rtc_core serio_raw rtc_lib scsi_wait_scan megaraid_mbox megaraid_mm sd_mod scsi_mod ext3 jbd mbcache
CPU:    1
EIP:    0060:[<c047102c>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.12-1 #1)
EIP is at fput+0x2/0x15
eax: 00000000   ebx: 00000000   ecx: 00009362   edx: 00000000
esi: 00000000   edi: cc6c0dc0   ebp: e342b480   esp: cf231f30
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process automount (pid: 15112, ti=cf230000 task=dff84870 task.ti=cf230000)
Stack: f8b60885 80049370 00000000 00000000 cc6c0dc0 f8b5f99f f625f588 f8b5f896
        e342b480 f8b5f896 00000000 c047a48f 00000000 00000000 00000000 00009362
        00000000 e342b480 00000000 00000004 c047a6de 00000002 c047a014 00000000
Call Trace:
  [<f8b60885>] autofs4_catatonic_mode+0x5a/0x66 [autofs4]
  [<f8b5f99f>] autofs4_root_ioctl+0x109/0x226 [autofs4]
  [<f8b5f896>] autofs4_root_ioctl+0x0/0x226 [autofs4]
  [<f8b5f896>] autofs4_root_ioctl+0x0/0x226 [autofs4]
  [<c047a48f>] do_ioctl+0x87/0x9f
  [<c047a6de>] vfs_ioctl+0x237/0x249
  [<c047a014>] do_fcntl+0xd2/0x249
  [<c047a73c>] sys_ioctl+0x4c/0x64
  [<c0404cc2>] sysenter_past_esp+0x5f/0x85
  =======================
Code: 7c 24 08 00 74 1b 8b 44 24 08 c7 40 64 00 00 00 00 8b 44 24 08 83 c4 
0c 5b 5e 5f 5d e9 7c 16 01 00 83 c4 0c 5b 5e 5f 5d c3 89 c2 <f0> ff 48 14 
0f 94 c0 84 c0 74 07 89 d0 e9 9c fe ff ff c3 56 85
EIP: [<c047102c>] fput+0x2/0x15 SS:ESP 0068:cf231f30

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko | *e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-137207086-1195616710=:22340--
