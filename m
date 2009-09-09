Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZIIUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZIIUtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZIIUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:49:18 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17718 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZIIUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:49:17 -0400
Subject: [PATCH 0/2] PCI Hotplug: internal interface cleanups
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Sep 2009 14:49:25 -0600
Message-ID: <20090909204738.11037.26974.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-post of an old patch series that wasn't picked up last
time due to being too late in the merge window.

It removes a bunch of copy/paste code in acpiphp by simplifying some
internal interfaces.

Please consider this for .32.

Thanks!

---

Alex Chiang (2):
      PCI Hotplug: acpiphp: find bridges the easy way
      PCI Hotplug: convert acpi_pci_detect_ejectable() to take an acpi_handle


 drivers/pci/hotplug/acpi_pcihp.c   |    9 +--
 drivers/pci/hotplug/acpiphp_glue.c |  104 +++++++++---------------------------
 drivers/pci/hotplug/pciehp_acpi.c  |    5 +-
 include/linux/pci_hotplug.h        |    2 -
 4 files changed, 34 insertions(+), 86 deletions(-)

