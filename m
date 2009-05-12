Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZELQvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZELQvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZELQuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:50:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:36907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZELQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:50:50 -0400
Date: Tue, 12 May 2009 16:48:28 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090512145128.GA10220@lenovo>
References: <20090512145128.GA10220@lenovo>
Subject: [tip:irq/numa] x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector(), fix
Message-ID: <tip-b5710ce92a8cf8e3fc0ffc230cfdbfa23463f1c8@git.kernel.org>
Git-Commit-ID: b5710ce92a8cf8e3fc0ffc230cfdbfa23463f1c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 16:48:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5710ce92a8cf8e3fc0ffc230cfdbfa23463f1c8
Gitweb:     http://git.kernel.org/tip/b5710ce92a8cf8e3fc0ffc230cfdbfa23463f1c8
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Tue, 12 May 2009 18:51:28 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 17:04:02 +0200

x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector(), fix

Fix trivial typo in the drivers/pci/hotplug/ibmphp_core.c changes.

[ Impact: build fix ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Yinghai Lu <yinghai@kernel.org>
Cc: eswierk@aristanetworks.com
LKML-Reference: <20090512145128.GA10220@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/pci/hotplug/ibmphp_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index ef53b05..79901a0 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -161,7 +161,7 @@ int ibmphp_init_devno(struct slot **cur_slot)
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i.
+						(int) (*cur_slot)->device, i,
 						&ioapic, &ioapic_pin,
 						&triggering, &polarity);
 
