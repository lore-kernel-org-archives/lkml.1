Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZC3QyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZC3QyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbZC3QuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:50:07 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:19136 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbZC3QuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:50:05 -0400
Subject: [PATCH v2 0/3] PCI core logical hotplug cleanup
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Mar 2009 10:50:04 -0600
Message-ID: <20090330164737.18855.7137.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of cleaning up the fallout between core logical hotplug and
physical hotplug drivers.

Thanks.

/ac

v1->v2:
	- clarify changelog
	- just use struct pci_slot->bus directly

---

Alex Chiang (3):
      PCI: pci_slot: grab refcount on slot's bus
      PCI Hotplug: acpiphp: grab refcount on p2p subordinate bus
      PCI: allow PCI core hotplug to remove PCI root bus


 drivers/acpi/pci_slot.c            |    5 +++++
 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
 drivers/pci/pci-sysfs.c            |    4 ----
 3 files changed, 19 insertions(+), 4 deletions(-)

