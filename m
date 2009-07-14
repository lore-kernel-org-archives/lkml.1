Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZGNUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZGNUx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZGNUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:53:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:15567 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZGNUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:53:24 -0400
Subject: [PATCH v2 0/2] ACPI/PCI: export acpi_pci_root to find pci_bus
	correctly
To: jbarnes@virtuousgeek.org, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 14 Jul 2009 14:53:23 -0600
Message-ID: <20090714204823.18933.40768.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of a patch series that:

	a) exports struct acpi_pci_root
	b) fixes an assumption in acpiphp about finding struct pci_bus

It's a minimal fix that's aimed at -rc4, as (b) fixes an assumption
introduced in -rc1.

I'll send the rest of the cleanups for linux-next later, after doing
some more testing.

Original thread here:
	http://thread.gmane.org/gmane.linux.kernel.pci/5080

v1 -> v2:
	- fixed build error in acpi_pci_root
	- reduced patch series in scope to be much smaller

---

Alex Chiang (2):
      ACPI: export acpi_pci_root and friends
      PCI Hotplug: acpiphp: get pci_bus from acpi handle correctly

 drivers/acpi/pci_root.c            |   17 ++---------------
 drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++-----------
 include/acpi/acpi_bus.h            |   16 ++++++++++++++++
 3 files changed, 34 insertions(+), 26 deletions(-)

