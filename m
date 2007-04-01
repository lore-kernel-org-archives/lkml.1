Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXDANpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXDANpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 09:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXDANpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 09:45:07 -0400
Received: from bart.webpack.hosteurope.de ([217.115.142.76]:42967 "EHLO
	bart.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933054AbXDANpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 09:45:05 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 09:45:05 EDT
Subject: Bug?
From: Sascha Curth <info@sascha-curth.de>
Reply-To: info@sascha-curth.de
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 01 Apr 2007 15:39:13 +0200
Message-Id: <1175434753.8986.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.2 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;info@sascha-curth.de;1175435105;ae249579;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i hav essen this in my logfiles. The server wasn't rechable any more and
a hard reset was needed....



Kernel: 2.6.18
Logfile:

Mar 29 22:18:07 seven ------------[ cut here ]------------
Mar 29 22:18:07 seven kernel BUG at mm/rmap.c:522!
Mar 29 22:18:07 seven invalid opcode: 0000 [#1]
Mar 29 22:18:07 seven SMP 
Mar 29 22:18:07 seven Modules linked in: capi capifs st fcdsl
Mar 29 22:18:07 seven CPU:    0
Mar 29 22:18:07 seven EIP:    0060:[<c0151a46>]    Tainted: P S    VLI
Mar 29 22:18:07 seven EFLAGS: 00210286   (2.6.18-gentoo-r3 #1) 
Mar 29 22:18:07 seven EIP is at page_remove_rmap+0x26/0x30
Mar 29 22:18:07 seven eax: ffffffff   ebx: d54dda88   ecx: c1ffaa40
edx: 00000000
Mar 29 22:18:07 seven esi: c1ffaa40   edi: b7ea2000   ebp: b7ea4000
esp: ca969edc
Mar 29 22:18:07 seven ds: 007b   es: 007b   ss: 0068
Mar 29 22:18:07 seven Process exim (pid: 14060, ti=ca968000
task=f6565580 task.ti=ca968000)
Mar 29 22:18:07 seven Stack: c014bb06 00000000 f639af98 ca969f48
00000000 00000001 d6f50b7c f7c1a900 
Mar 29 22:18:07 seven c200be20 00000000 fffffffc c12a9bac d6f50b7c
7fd52025 b7ea3fff 00294bfc 
Mar 29 22:18:07 seven b7ea4000 00000000 ca969f48 dd471128 f7c1a900
ca968000 c014e989 ffffffff 
Mar 29 22:18:07 seven Call Trace:
Mar 29 22:18:07 seven [<c014bb06>] unmap_vmas+0x286/0x520
Mar 29 22:18:07 seven [<c014e989>] exit_mmap+0x79/0x100
Mar 29 22:18:07 seven [<c011b9c3>] mmput+0x33/0xa0
Mar 29 22:18:07 seven [<c0120c23>] do_exit+0xf3/0x8b0
Mar 29 22:18:07 seven [<c01126b7>] do_page_fault+0xe7/0x5ab
Mar 29 22:18:07 seven [<c0121413>] do_group_exit+0x33/0x90
Mar 29 22:18:07 seven [<c0102e2d>] sysenter_past_esp+0x56/0x79
Mar 29 22:18:07 seven Code: bf 00 00 00 00 89 c1 90 83 40 08 ff 0f 98 c0
84 c0 75 02 f3 c3 8b 41 08 40 78 10 8b 51 10 89 c8 83 f2 01 83 e2 01 e9
ba 81 ff f
f <0f> 0b 0a 02 88 90 51 c0 eb e6 83 ec 20 89 74 24 14 89 d6 89 5c 
Mar 29 22:18:07 seven EIP: [<c0151a46>] page_remove_rmap+0x26/0x30
SS:ESP 0068:ca969edc
Mar 29 22:18:07 seven <1>Fixing recursive fault but reboot is needed!


