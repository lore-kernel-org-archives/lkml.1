Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYEPVqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYEPVqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYEPVqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:46:37 -0400
Received: from smtp-1.sys.kth.se ([130.237.32.175]:59389 "EHLO
	smtp-1.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYEPVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:46:36 -0400
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 17:46:36 EDT
Message-Id: <315ECD9C-F840-4758-90D0-49EBACECE308@kth.se>
From: Marc Rantanen <marcr@kth.se>
To: linux-kernel@vger.kernel.org, support@highpoint-tech.com,
       support@microaurora.com.cn
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Oops: 0000 [#1] SMP //// HPT raid card 1740 
Date: Fri, 16 May 2008 23:14:06 +0200
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't get the new driver for HPT 1740 working in kernel gentoo-2.6.24-r8

module: rr174x (v.2.1)

/marc
------------------------
rr174x: module license 'Proprietary' taints kernel.
rr174x:RocketRAID 174x controller driver v2.1.08.0303 (May 16 2008  
15:58:03)
BUG: unable to handle kernel paging request at virtual address 64091fd0
printing eip: f8905688 *pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: rr174x(P) scsi_wait_scan

Pid: 3411, comm: modprobe Tainted: P        (2.6.24-gentoo-r8 #1)
EIP: 0060:[<f8905688>] EFLAGS: 00010a17 CPU: 0
EIP is at f8e22123f+0x18/0x50 [rr174x]
EAX: 00000000 EBX: f74ef9a8 ECX: f8931d60 EDX: 6b7601f0
ESI: f74ef980 EDI: ffffffed EBP: f8932580 ESP: f75ebe44
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 3411, ti=f75ea000 task=f7d0fa40 task.ti=f75ea000)
Stack: f8903b85 f892b34c f8931d60 f8931da0 f7d0fa40 00000000 f8931ca0  
f8931e20
        00000000 f7c4ca80 c06643ec c0140cfa 7fffffff c01216a4 c0431095  
c04310b9
        00000002 f75ebe90 00000000 c0140cfa f8932580 00000282 f74ef9a8  
f74ef980
Call Trace:
  [<f8903b85>] hpt_detect+0x20e/0x6d8 [rr174x]
  [<c0140cfa>] __link_module+0x0/0x1f
  [<c01216a4>] __cond_resched+0x13/0x30
  [<c0431095>] cond_resched+0x23/0x2c
  [<c04310b9>] wait_for_common+0x1b/0x114
  [<c0140cfa>] __link_module+0x0/0x1f
  [<f893505c>] init_this_scsi_driver+0x5c/0xd9 [rr174x]
  [<c0143093>] sys_init_module+0x14bd/0x15e0
  [<c0104df2>] sysenter_past_esp+0x5f/0x85
  =======================
Code: 00 00 00 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 8b 54  
24 04 31 c0 8b 4c 24 08 3b 15 08 1e 93 f8 7d 32 8d 14 92 c1 e2 02 <$
EIP: [<f8905688>] f8e22123f+0x18/0x50 [rr174x] SS:ESP 0068:f75ebe44
---[ end trace 90ba0736762312ae ]---

