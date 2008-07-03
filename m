Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYGCNIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYGCNIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761937AbYGCNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:07:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:54590 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761922AbYGCNHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=msNG2RF2t7gVdUTsbe6lRo4rMhppRXHeAKZu5D7aIxNMBL0ke/uaUx42qu7bPDlcwk
         e0J1f9GZprrvS18JtQZW8ORZOEsJXItOrZP160Nj6t2d1KR3R6sNTDHNHBjylK+6pGXg
         ehrUHbm8xF6SUDe8P2Lvc8B+6YrqMx1YgaEwc=
Message-ID: <a4423d670807030607s28bc7205l3bf46b49cff4176d@mail.gmail.com>
Date: Thu, 3 Jul 2008 17:07:42 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: ak@linux.intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: next-0702: ACPI Error (nseval-0159): Insufficient arguments
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have several these messages.
It is Dual-Core Opteron 1214.

CONFIG_ACPI=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_PNPACPI=y

Let me know if you need more info.

[    0.888708] WARNING: at nseval:159 acpi_ut_error+0x32/0xa2()
[    0.888708] Modules linked in:
[    0.888708] Pid: 1, comm: swapper Not tainted 2.6.26-rc8-next-20080702 #1
[    0.888708]
[    0.888708] Call Trace:
[    0.888708]  [<ffffffff8022f47b>] warn_on_slowpath+0x58/0x87
[    0.888708]  [<ffffffff8024ea02>] ? __lock_acquire+0xd25/0xd71
[    0.888708]  [<ffffffff8027f79e>] ? check_bytes_and_report+0x38/0xcb
[    0.888708]  [<ffffffff803606c8>] ? acpi_ns_get_node+0x94/0xa4
[    0.888708]  [<ffffffff8027fbf5>] ? check_object+0x15a/0x245
[    0.888708]  [<ffffffff8027f483>] ? init_object+0x6e/0x77
[    0.888708]  [<ffffffff8024d875>] ? trace_hardirqs_on+0xd/0xf
[    0.888708]  [<ffffffff80366be9>] acpi_ut_error+0x32/0xa2
[    0.888708]  [<ffffffff8024d875>] ? trace_hardirqs_on+0xd/0xf
[    0.888708]  [<ffffffff803606c8>] ? acpi_ns_get_node+0x94/0xa4
[    0.888708]  [<ffffffff803606c8>] ? acpi_ns_get_node+0x94/0xa4
[    0.888708]  [<ffffffff8024d83d>] ? trace_hardirqs_on_caller+0xf9/0x124
[    0.888708]  [<ffffffff8024d875>] ? trace_hardirqs_on+0xd/0xf
[    0.888708]  [<ffffffff80367740>] ?
acpi_ut_copy_eobject_to_iobject+0x18c/0x20a
[    0.888708]  [<ffffffff803668f1>] ? acpi_ut_valid_acpi_name+0x1f/0x3c
[    0.888708]  [<ffffffff8035fefe>] acpi_ns_evaluate+0x10e/0x1b4
[    0.888708]  [<ffffffff8035fa4e>] acpi_evaluate_object+0x136/0x1f4
[    0.888708]  [<ffffffff8027fbf5>] ? check_object+0x15a/0x245
[    0.888708]  [<ffffffff8034d710>] acpi_run_osc+0xa5/0x16b
[    0.888708]  [<ffffffff8034d866>] pci_osc_control_set+0x90/0xa7
[    0.888708]  [<ffffffff80349446>] aer_osc_setup+0x66/0xbc
[    0.888708]  [<ffffffff80348533>] aer_init+0x9/0x1f
[    0.888708]  [<ffffffff80469042>] aer_probe+0x13/0x16d
[    0.888708]  [<ffffffff80347d0a>] pcie_port_probe_service+0x3a/0x84
[    0.888708]  [<ffffffff8038ed99>] driver_probe_device+0xd9/0x169
[    0.888708]  [<ffffffff8038ee78>] __driver_attach+0x4f/0x79
[    0.888708]  [<ffffffff8038ee29>] ? __driver_attach+0x0/0x79
[    0.888708]  [<ffffffff8038e3e8>] bus_for_each_dev+0x4d/0x7e
[    0.888708]  [<ffffffff8038ebc7>] driver_attach+0x1c/0x1e
[    0.888708]  [<ffffffff8038e876>] bus_add_driver+0xba/0x210
[    0.888708]  [<ffffffff805f2ec2>] ? aer_service_init+0x0/0x20
[    0.888708]  [<ffffffff8038f056>] driver_register+0x93/0x10a
[    0.888708]  [<ffffffff805f2ec2>] ? aer_service_init+0x0/0x20
[    0.888708]  [<ffffffff803477eb>] pcie_port_service_register+0x47/0x49
[    0.888708]  [<ffffffff805f2ee0>] aer_service_init+0x1e/0x20
[    0.888708]  [<ffffffff805e0963>] kernel_init+0x142/0x29d
[    0.888708]  [<ffffffff8024d83d>] ? trace_hardirqs_on_caller+0xf9/0x124
[    0.888708]  [<ffffffff8024d875>] ? trace_hardirqs_on+0xd/0xf
[    0.888708]  [<ffffffff8046f968>] ? _spin_unlock_irq+0x2b/0x31
[    0.888708]  [<ffffffff8046f30e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.888708]  [<ffffffff8024d83d>] ? trace_hardirqs_on_caller+0xf9/0x124
[    0.888708]  [<ffffffff8020c0a8>] child_rip+0xa/0x12
[    0.888708]  [<ffffffff8020b7bf>] ? restore_args+0x0/0x30
[    0.888708]  [<ffffffff805e0821>] ? kernel_init+0x0/0x29d
[    0.888708]  [<ffffffff8020c09e>] ? child_rip+0x0/0x12
[    0.888708]
[    0.888708] ---[ end trace a7919e7f17c0a725 ]---
[    0.888708] ACPI Error (nseval-0159): Insufficient arguments -
method [_OSC] needs 5, found 4 [20080609]
[    0.888708] aer 0000:00:0a.0:pcie01: AER service couldn't init
device: _OSC failed
