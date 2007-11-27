Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXK0Kb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXK0Kb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXK0Kbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:31:49 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:8325 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXK0Kbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:31:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DoBzmN50PlOMkgdJUp3Lqhq2Hhh0bB8ojF65Sns37oGbJh8ZJrTM9WVeXcbJ5i/76NtS00xbtwBW6OyAqWwYwBEyiirdKd+8YMcn6w/ztgUjDF8P/28OPvFAC4QKYJDCyzGU6lVtGpBk9SOd0nxW8Uq6e8jHxARDtoc3D/nfsmU=
Date: Tue, 27 Nov 2007 18:32:39 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marco Pracucci <development@pracucci.com>
Cc: marcel@holtmann.org, bluez-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Bluez-devel] 2.6.23.8: kernel panic
Message-ID: <20071127103239.GA4477@darkstar.te-china.tietoenator.com>
References: <4746EC10.5080509@pracucci.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4746EC10.5080509@pracucci.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 04:04:48PM +0100, Marco Pracucci wrote:
> Hi,
> 
> I have compiled linux kernel 2.6.23.8 for a single board computer based
> on ARM architecture (EP9302 processor). I have tried to stress the
> Bluetooth subsystem, creating repeatly a lot of RFCOMM connections to
> other Bluetooth dongles (installed on remote computers) and I'm able to
> get a kernel panic in few minutes.
> 
> Unable to handle kernel paging request at virtual address 57ac5e8c
> pgd = c12ac000
> [57ac5e8c] *pgd=00000000
> Internal error: Oops: 5 [#1]
> Modules linked in:
> CPU: 0    Not tainted  (2.6.23.8 #1)
> PC is at hci_get_route+0x50/0x110
> LR is at 0x6
> pc : [<c020234c>]    lr : [<00000006>]    psr: 90000013
> sp : c14cfe70  ip : 00000001  fp : c14cfe94
> r10: 0000014c  r9 : 00000002  r8 : c001efe4
> r7 : c174a33a  r6 : 00000077  r5 : c174a334  r4 : 57ac5e78
> r3 : c02dfc1c  r2 : 00000067  r1 : c174a334  r0 : fffffff0
> Flags: NzcV  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 4000717f  Table: 012ac000  DAC: 00000015
> Process test (pid: 4457, stack limit = 0xc14ce258)
> Stack: (0xc14cfe70 to 0xc14d0000)
> fe60:                                     0000fecc 00000000 c174a33a
> 00000001
> fe80: c174a200 c174a334 c14cfec8 c14cfe98 c0207f8c c020230c c14cfecc
> c001efe4
> fea0: 7e5ff9c4 c150e900 0000000c c14cfecc c001efe4 c14ce000 2aae7c38
> c14cff70
> fec0: c14cfecc c0197de4 c0207ec4 0001001f 0d4e16e1 2ae0000b c14cff18
> c02ed6f4
> fee0: c03214f4 c14cff14 c1690b3c c1690ae4 c150e93c c14cff14 c14cff04
> c008d930
> ff00: c00a5540 c160a220 c14cff3c c14cff18 c019834c c008d8f8 00000000
> 00000000
> ff20: c02790a4 00000009 00000009 2ae033a4 c14cff58 c14cff40 c0198724
> c007aa94
> ff40: c160a220 00000001 2ae033a0 00000001 00000000 00000003 2ae033a0
> 2ae033a4
> ff60: 00000066 c14cffa4 c14cff74 c01991a8 c0197d7c c00365c0 00000000
> 00000009
> ff80: 7e5ff9c4 0000000c c14cffa4 c14cff98 c003696c 0003f560 00000000
> c14cffa8
> ffa0: c001ee40 c01990b8 0003f560 2ae033a0 00000003 7e5ff998 00000000
> 00000001
> ffc0: 0003f560 2ae033a0 2ae033a4 2ae007e8 00000001 7e5ffaec 2aae7c38
> 7e5ff9f4
> ffe0: 00000000 7e5ff994 2ab7ed60 2ab7ed70 60000010 00000003 00000000
> 00000000
> Backtrace:
> [<c02022fc>] (hci_get_route+0x0/0x110) from [<c0207f8c>]
> (l2cap_sock_connect+0xd8/0x2f0)
>  r7:c174a334 r6:c174a200 r5:00000001 r4:c174a33a
> [<c0207eb4>] (l2cap_sock_connect+0x0/0x2f0) from [<c0197de4>]
> (sys_connect+0x78/0x98)
> [<c0197d6c>] (sys_connect+0x0/0x98) from [<c01991a8>]
> (sys_socketcall+0x100/0x1f0)
>  r7:00000066 r6:2ae033a4 r5:2ae033a0 r4:00000003
> [<c01990a8>] (sys_socketcall+0x0/0x1f0) from [<c001ee40>]
> (ret_fast_syscall+0x0/0x2c)
>  r4:0003f560
> Code: ebf8f094 e59f30c0 e5934000 ea000016 (e5943014)
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> I have also attached the system log. I hope it helps.
> 
> Marco Pracucci
> 

> Nov 23 13:55:02   user.err kernel: kobject_add failed for acl000B0D4E09E4 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:55:02   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:55:02   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:55:02   user.warn kernel:  r8:c16416f0 r7:00000000 r6:c0205964 r5:c1641688 r4:c030da20
> Nov 23 13:55:02   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:55:02   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:55:02   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:55:02   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:55:02   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:55:02   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:55:02   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:55:02   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:55:02   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:55:02   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:55:02   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:12   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:13   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:22   user.err kernel: kobject_add failed for acl000B0D4E09E4 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:55:22   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:55:22   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:55:22   user.warn kernel:  r8:c1497af0 r7:00000000 r6:c0205964 r5:c1497a88 r4:c030da20
> Nov 23 13:55:22   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:55:22   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:55:22   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:55:22   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:55:22   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:55:22   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:55:22   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:55:22   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:55:22   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:55:22   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:55:22   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:23   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:33   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:34   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:43   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:44   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:47   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:52   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:54   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:55:57   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:05   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:05   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:05   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:05   user.warn kernel:  r8:c15c50f0 r7:00000000 r6:c0205964 r5:c15c5088 r4:c030da20
> Nov 23 13:56:05   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:05   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:05   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:05   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:05   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:05   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:05   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:05   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:05   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:05   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:05   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:06   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:24   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:26   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:27   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:34   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:34   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:34   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:34   user.warn kernel:  r8:c1564cf0 r7:00000000 r6:c0205964 r5:c1564c88 r4:c030da20
> Nov 23 13:56:34   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:34   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:34   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:34   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:34   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:34   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:34   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:34   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:34   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:34   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:34   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:34   user.err kernel: kobject_add failed for acl0007808103E0 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:34   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:34   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:34   user.warn kernel:  r8:c14978f0 r7:00000000 r6:c0205964 r5:c1497888 r4:c030da20
> Nov 23 13:56:34   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:34   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:34   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:34   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:34   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:34   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:34   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:34   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:34   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:34   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:34   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:42   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:43   user.warn kernel: WARNING: at lib/kref.c:33 kref_get()
> Nov 23 13:56:43   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011ff48>] (kref_get+0x34/0x60)
> Nov 23 13:56:43   user.warn kernel: [<c011ff14>] (kref_get+0x0/0x60) from [<c011f0ac>] (kobject_get+0x18/0x20)
> Nov 23 13:56:43   user.warn kernel:  r4:c15c5cf0
> Nov 23 13:56:43   user.warn kernel: [<c011f094>] (kobject_get+0x0/0x20) from [<c013c084>] (get_device+0x1c/0x28)
> Nov 23 13:56:43   user.warn kernel:  r4:c030da20
> Nov 23 13:56:43   user.warn kernel: [<c013c068>] (get_device+0x0/0x28) from [<c013ce74>] (device_add+0x14/0x558)
> Nov 23 13:56:43   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:43   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:43   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:43   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:43   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:43   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:43   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:43   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:43   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:44   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:44   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:44   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:44   user.warn kernel:  r8:c1641cf0 r7:00000000 r6:c0205964 r5:c1641c88 r4:c030da20
> Nov 23 13:56:44   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:44   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:44   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:44   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:44   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:44   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:44   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:44   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:44   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:44   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:44   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:44   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:44   user.err kernel: kobject_add failed for acl0007808103EA with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:44   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:44   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:44   user.warn kernel:  r8:c1282cf0 r7:00000000 r6:c0205964 r5:c1282c88 r4:c030da20
> Nov 23 13:56:44   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:44   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:44   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:44   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:44   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:44   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:44   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:44   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:44   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:44   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:44   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:52   user.err kernel: kobject_add failed for acl000B0D4C623C with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:52   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:52   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:52   user.warn kernel:  r8:c1641ef0 r7:00000000 r6:c0205964 r5:c1641e88 r4:c030da20
> Nov 23 13:56:52   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:52   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:52   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:52   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:52   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:52   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:52   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:52   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:52   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:52   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:52   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:52   user.err kernel: kobject_add failed for acl000B0D4E1D9F with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:52   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:52   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:52   user.warn kernel:  r8:c15646f0 r7:00000000 r6:c0205964 r5:c1564688 r4:c030da20
> Nov 23 13:56:52   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:52   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:52   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:52   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:52   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:52   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:52   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:52   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:52   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:52   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:52   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:53   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:53   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:53   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:53   user.warn kernel:  r8:c15c56f0 r7:00000000 r6:c0205964 r5:c15c5688 r4:c030da20
> Nov 23 13:56:53   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:53   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:53   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:53   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:53   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:53   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:53   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:53   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:53   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:53   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:53   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:54   user.err kernel: kobject_add failed for acl0007808103EA with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:54   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:54   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:54   user.warn kernel:  r8:c15644f0 r7:00000000 r6:c0205964 r5:c1564488 r4:c030da20
> Nov 23 13:56:54   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:54   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:54   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:54   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:54   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:54   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:54   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:54   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:54   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:54   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:54   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:56:54   user.err kernel: kobject_add failed for acl0007808103E0 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:56:54   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:56:54   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:56:54   user.warn kernel:  r8:c4084cf0 r7:00000000 r6:c0205964 r5:c4084c88 r4:c030da20
> Nov 23 13:56:54   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:56:54   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:56:54   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:56:54   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:56:54   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:56:54   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:56:54   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:56:54   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:56:54   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:56:54   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:56:54   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:03   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:04   user.err kernel: kobject_add failed for acl000B0D4C623C with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:04   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:04   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:04   user.warn kernel:  r8:c16bdcf0 r7:00000000 r6:c0205964 r5:c16bdc88 r4:c030da20
> Nov 23 13:57:04   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:04   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:04   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:04   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:04   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:04   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:04   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:04   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:04   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:04   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:04   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:04   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:04   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:04   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:04   user.warn kernel:  r8:c17556f0 r7:00000000 r6:c0205964 r5:c1755688 r4:c030da20
> Nov 23 13:57:04   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:04   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:04   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:04   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:04   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:04   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:04   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:04   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:04   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:04   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:04   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:04   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:12   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:13   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:16   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:16   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:16   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:16   user.warn kernel:  r8:c15c50f0 r7:00000000 r6:c0205964 r5:c15c5088 r4:c030da20
> Nov 23 13:57:16   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:16   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:16   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:16   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:16   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:16   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:16   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:16   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:16   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:16   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:16   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:16   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:22   user.err kernel: kobject_add failed for acl000B0D4C623C with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:22   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:22   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:22   user.warn kernel:  r8:c40846f0 r7:00000000 r6:c0205964 r5:c4084688 r4:c030da20
> Nov 23 13:57:22   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:22   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:22   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:22   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:22   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:22   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:22   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:22   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:22   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:22   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:22   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:26   user.err kernel: kobject_add failed for acl000B0D4D5893 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:26   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:26   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:26   user.warn kernel:  r8:c15c52f0 r7:00000000 r6:c0205964 r5:c15c5288 r4:c030da20
> Nov 23 13:57:26   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:26   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:26   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:26   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:26   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:26   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:26   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:26   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:26   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:26   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:26   user.err kernel: add_conn: Failed to register connection device
> Nov 23 13:57:26   user.err kernel: kobject_add failed for acl0007808103E0 with -EEXIST, don't try to register things with the same name in the same directory.
> Nov 23 13:57:26   user.warn kernel: [<c0022a34>] (dump_stack+0x0/0x14) from [<c011f420>] (kobject_shadow_add+0x15c/0x1a8)
> Nov 23 13:57:26   user.warn kernel: [<c011f2c4>] (kobject_shadow_add+0x0/0x1a8) from [<c011f480>] (kobject_add+0x14/0x18)
> Nov 23 13:57:26   user.warn kernel:  r8:c15644f0 r7:00000000 r6:c0205964 r5:c1564488 r4:c030da20
> Nov 23 13:57:26   user.warn kernel: [<c011f46c>] (kobject_add+0x0/0x18) from [<c013cee4>] (device_add+0x84/0x558)
> Nov 23 13:57:26   user.warn kernel: [<c013ce60>] (device_add+0x0/0x558) from [<c020597c>] (add_conn+0x18/0x70)
> Nov 23 13:57:26   user.warn kernel: [<c0205964>] (add_conn+0x0/0x70) from [<c0048a2c>] (run_workqueue+0xb4/0x144)
> Nov 23 13:57:26   user.warn kernel:  r5:c0334000 r4:c030da20
> Nov 23 13:57:26   user.warn kernel: [<c0048978>] (run_workqueue+0x0/0x144) from [<c0048c80>] (worker_thread+0xa4/0xb8)
> Nov 23 13:57:26   user.warn kernel:  r6:c0048bdc r5:c030da20 r4:c030da28
> Nov 23 13:57:26   user.warn kernel: [<c0048bdc>] (worker_thread+0x0/0xb8) from [<c004c680>] (kthread+0x5c/0x90)
> Nov 23 13:57:26   user.warn kernel:  r5:c030da20 r4:c0334000
> Nov 23 13:57:27   user.warn kernel: [<c004c624>] (kthread+0x0/0x90) from [<c003b79c>] (do_exit+0x0/0x724)
> Nov 23 13:57:27   user.warn kernel:  r6:00000000 r5:00000000 r4:00000000
> Nov 23 13:57:27   user.err kernel: add_conn: Failed to register connection device

This problem is caused by the workqueue in hci_sysfs.c, the del_conn is scheduled after the add_conn with same bluetooth address.

Please try this patch:
----------------------------

The bluetooth hci conn sysfs add/del executed in the default workqueue. If the conn del function is executed after the new conn add function with same bluetooth target address, the connection add will failed and warning about same kobject name.

Here add a btconn workqueue, and flush the workqueue in the add_conn function to avoid the above issue. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_sysfs.c |   15 ++++++++++++++-
1 file changed, 14 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2007-11-27 18:11:11.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2007-11-27 18:25:02.000000000 +0800
@@ -12,6 +12,7 @@
 #undef  BT_DBG
 #define BT_DBG(D...)
 #endif
+static struct workqueue_struct *btconn;
 
 static inline char *typetostr(int type)
 {
@@ -279,6 +280,7 @@ static void add_conn(struct work_struct 
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 	int i;
 
+	flush_workqueue(btconn);
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
 		return;
@@ -313,6 +315,7 @@ void hci_conn_add_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, add_conn);
 
+	queue_work(btconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -331,6 +334,7 @@ void hci_conn_del_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, del_conn);
 
+	queue_work(btconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -380,18 +384,26 @@ int __init bt_sysfs_init(void)
 {
	int err;
 
+	btconn = create_singlethread_workqueue("btconn");
+	if (!btconn)
+		return -ENOMEM;
+
 	bt_platform = platform_device_register_simple("bluetooth", -1, NULL, 0);
-	if (IS_ERR(bt_platform))
+	if (IS_ERR(bt_platform)) {
+		destroy_workqueue(btconn);
 		return PTR_ERR(bt_platform);
+	}
 
 	err = bus_register(&bt_bus);
 	if (err < 0) {
+		destroy_workqueue(btconn);
 		platform_device_unregister(bt_platform);
 		return err;
 	}
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
+		destroy_workqueue(btconn);
 		bus_unregister(&bt_bus);
 		platform_device_unregister(bt_platform);
 		return PTR_ERR(bt_class);
@@ -402,6 +414,7 @@ int __init bt_sysfs_init(void)
 
 void bt_sysfs_cleanup(void)
 {
+	destroy_workqueue(btconn);
 	class_destroy(bt_class);
 
 	bus_unregister(&bt_bus);
