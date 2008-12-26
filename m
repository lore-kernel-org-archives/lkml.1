Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYLZLbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYLZLbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 06:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYLZLbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 06:31:36 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3377 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYLZLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 06:31:35 -0500
Message-ID: <4954C095.3080300@xs4all.nl>
Date: Fri, 26 Dec 2008 12:31:33 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG or virtualbox issue?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just started virtualbox for the first time on x86_64 Phenom system; is 
this a kernel issue or something for the VirtualBox people?

Dec 26 12:20:01 surfplank2 kernel: BUG: using smp_processor_id() in 
preemptible [00000000] code: VirtualBox/26774
Dec 26 12:20:01 surfplank2 kernel: caller is RTMpCpuId+0x9/0x10 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: Pid: 26774, comm: VirtualBox Not 
tainted 2.6.28 #3
Dec 26 12:20:01 surfplank2 kernel: Call Trace:
Dec 26 12:20:01 surfplank2 kernel: [<ffffffff8036c964>] 
debug_smp_processor_id+0xd4/0xe0
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03976a9>] 
RTMpCpuId+0x9/0x10 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03a59c3>] 
g_abExecMemory+0x6403/0x180000 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03a46a8>] 
g_abExecMemory+0x50e8/0x180000 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03aedb7>] 
g_abExecMemory+0xf7f7/0x180000 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03af232>] 
g_abExecMemory+0xfc72/0x180000 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa03af0e7>] 
g_abExecMemory+0xfb27/0x180000 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa0392a9d>] 
supdrvIOCtl+0xfbd/0x1e00 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa0395f55>] 
rtMemAlloc+0x85/0xf0 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffffa038e2d4>] 
VBoxDrvLinuxIOCtl+0x114/0x1f0 [vboxdrv]
Dec 26 12:20:01 surfplank2 kernel: [<ffffffff802bb75f>] vfs_ioctl+0x2f/0xa0
Dec 26 12:20:01 surfplank2 kernel: [<ffffffff802bb84c>] 
do_vfs_ioctl+0x7c/0x470
Dec 26 12:20:01 surfplank2 kernel: [<ffffffff802bbce1>] sys_ioctl+0xa1/0xb0
Dec 26 12:20:01 surfplank2 kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b


Udo
