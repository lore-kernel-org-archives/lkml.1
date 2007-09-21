Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbXIUXzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbXIUXzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbXIUXzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:55:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbXIUXzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:55:46 -0400
Message-ID: <46F45A00.6040505@redhat.com>
Date: Fri, 21 Sep 2007 19:55:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Doug Thompson <norsk5@xmission.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: edac_mc: sleeping function called from invalid context
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.22.6:

# echo "1" >/sys/devices/system/edac/pci/check_pci_parity
# dmesg | tail -14
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1

Call Trace:
 [<ffffffff81048161>] down_read+0x15/0x24
 [<ffffffff81123b90>] pci_get_subsys+0x81/0x113
 [<ffffffff8126cfe5>] schedule_timeout+0x85/0xad
 [<ffffffff88347b9e>] :edac_mc:edac_kernel_thread+0x9e/0x104
 [<ffffffff88347b00>] :edac_mc:edac_kernel_thread+0x0/0x104
 [<ffffffff810457e8>] kthread+0x47/0x73
 [<ffffffff8100a978>] child_rip+0xa/0x12
 [<ffffffff810457a1>] kthread+0x0/0x73
 [<ffffffff8100a96e>] child_rip+0x0/0x12
