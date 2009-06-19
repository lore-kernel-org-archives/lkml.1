Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZFSMTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZFSMTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZFSMTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:19:37 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:1840 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZFSMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <fae6a9700906190518r3840f5fchb303258a27d66b73@mail.gmail.com>
References: <fae6a9700906190518r3840f5fchb303258a27d66b73@mail.gmail.com>
Date: Fri, 19 Jun 2009 17:49:38 +0530
Message-ID: <fae6a9700906190519u1fbdce71m9910d8d7b3248b25@mail.gmail.com>
Subject: Crash occurs while NFS mounting of RFS
From: Vivek Satpute <vivek@linsyssoft.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to do NFS mounted RFS and while doing that, before RFS get
mounted, I get
following call-trace. ( CONFIG_LOCKDEP is enabled in kernel )

Looking up port of RPC 100003/2 on 192.168.1.18

------------[ cut here ]------------
WARNING: at kernel/sched.c:4995 local_bh_enable+0x60/0x1a4()
Modules linked in:
Call Trace:
[<80111770>] dump_stack+0x8/0x34
[<8012e9a8>] warn_on_slowpath+0x60/0x88
[<80135d4c>] local_bh_enable+0x60/0x1a4
[<8035e23c>] lock_sock_nested+0xf8/0x11c
[<803bcd88>] inet_bind+0x100/0x210
[<803d8a68>] xs_bind4+0x70/0x158
[<803dac80>] xs_udp_connect_worker4+0x120/0x1a4
[<801441d8>] run_workqueue+0x1d0/0x288
[<801451b0>] worker_thread+0x7c/0xec
[<80149074>] kthread+0x58/0x94
[<8010cc34>] kernel_thread_helper+0x10/0x18

---[ end trace cde2c19f73cb7209 ]---


I am not getting from where I should start ? Could anyone please
suggest me what can be the problem and how to fix it to make
NFS mounting working.

Any comments will be appreciated. Thanks in advance.

Thanks again,
Vivek Satpute
