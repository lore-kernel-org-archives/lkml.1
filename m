Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbZC2Qyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbZC2Qyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZC2Qyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:54:41 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17684 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZC2Qyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:54:40 -0400
Subject: [PATCH 0/3] PCI core logical hotplug cleanup
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 29 Mar 2009 10:54:38 -0600
Message-ID: <20090329165352.29073.5159.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

This series cleans up some of the fallout from the poor interaction
between PCI core logical hotplug and acpiphp/pci_slot.

I'm taking a piecemeal approach for now because I don't have a good
solution that can fix all the drivers at once.

I tested pci_slot and acpiphp on my machine, and it seems to solve the
issue that Kenji-san reported.

Thanks.

/ac

---

Alex Chiang (3):
      PCI: pci_slot: grab refcount on slot's bus
      PCI Hotplug: acpiphp: grab refcount on p2p subordinate bus
      PCI: allow PCI core hotplug to remove PCI root bus


 drivers/acpi/pci_slot.c            |    5 +++++
 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
 drivers/pci/pci-sysfs.c            |    4 ----
 3 files changed, 19 insertions(+), 4 deletions(-)

