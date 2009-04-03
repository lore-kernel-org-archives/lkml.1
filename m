Return-Path: <linux-kernel-owner+w=401wt.eu-S936952AbZDCWBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936952AbZDCWBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759955AbZDCWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:01:33 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38557 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759402AbZDCWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:01:32 -0400
Subject: [PATCH v2] PCI: Add support for turning PCIe ECRC on or off
To: linux-pci@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Fri, 03 Apr 2009 16:01:31 -0600
Message-ID: <20090403220131.22113.56040.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version two of my patch to add PCIe ECRC support

Changelog:

Fixed copyright year typo.
Removed unneeded EXPORT_SYMBOL_GPL.
Use pci=ecrc=<option> instead of pcie_ecrc=<option>.
Use "bios" instead of "default" to indicate ECRC should be set by firmware.
Use CONFIG_PCIE_ECRC instead of CONFIG_PCIEECRC.

 Documentation/kernel-parameters.txt |    6 ++
 drivers/pci/pci.c                   |    2 +
 drivers/pci/pcie/Kconfig            |   12 +++++
 drivers/pci/pcie/Makefile           |    2 +
 drivers/pci/pcie/ecrc.c             |   91 +++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c                 |    3 +
 include/linux/pci.h                 |   11 ++++
 7 files changed, 127 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/pcie/ecrc.c


-- 
Andrew Patterson

