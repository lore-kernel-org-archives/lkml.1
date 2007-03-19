Return-Path: <linux-kernel-owner+w=401wt.eu-S933951AbXCSOI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbXCSOI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXCSOI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:08:28 -0400
Received: from outmx019.isp.belgacom.be ([195.238.4.200]:53278 "EHLO
	outmx019.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933951AbXCSOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:08:27 -0400
Subject: Oops on serial access using diskless fanless puppylinux
From: Gerd Luyten <gluyten@skynet.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 19 Mar 2007 15:08:07 +0100
Message-Id: <1174313288.8249.4.camel@workstation.dyn.nu>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


BUG: unable to handle kernel NULL pointer dereference at virtual address
00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: lp parport_pc parport rt73 8139too mii fuse unionfs
nls_iso8859_1 nls_cp437 sr_mod ide_cd cdrom ohci_hcd usbcore
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010206   (2.6.18.1 #1)
EIP is at rest_init+0x3feffdc0/0x20
eax: ffffff05   ebx: 00000000   ecx: 00000000   edx: 000002f9
esi: 00000292   edi: 00000040   ebp: 00000000   esp: c2345e48
ds: 007b   es: 007b   ss: 0068
Process solarmax (pid: 11939, ti=c2344000 task=c7b03a90
task.ti=c2344000)
Stack: c046add0 00000001 00000005 c78eb360 c046add0 c7b766f0 00000000
c02779ca
       c046add0 c7b766f0 c3ab5000 c7b766f0 c4a26e40 c0279328 c7b766f0
00000000
       ffffffed c4a26e40 00400041 00000100 c0265f14 c3ab5000 c4a26e40
0102ca04
Call Trace:
 [<c02779ca>] uart_startup+0xaa/0x130
 [<c0279328>] uart_open+0x88/0x100
 [<c0265f14>] tty_open+0x224/0x350
 [<c015ade8>] chrdev_open+0x98/0x130
 [<c015ad50>] chrdev_open+0x0/0x130
 [<c0151564>] __dentry_open+0x154/0x210
 [<c0151723>] nameidata_to_filp+0x23/0x40
 [<c0151667>] do_filp_open+0x47/0x50
 [<c0142e8c>] do_anonymous_page+0xac/0x130
 [<c022658e>] strncpy_from_user+0x2e/0x50
 [<c0151910>] do_sys_open+0x40/0xd0
 [<c01519b6>] sys_open+0x16/0x20
 [<c0102f07>] syscall_call+0x7/0xb
Code:  Bad EIP value.
EIP: [<00000000>] rest_init+0x3feffdc0/0x20 SS:ESP 0068:c2345e48




