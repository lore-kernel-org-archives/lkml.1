Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZDVWwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZDVWwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZDVWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:52:07 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:25412 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDVWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:52:06 -0400
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH v3] PCI: Add support for turning PCIe ECRC on or off
To: linux-pci@vger.kernel.org
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com
Date: Wed, 22 Apr 2009 16:52:03 -0600
Message-ID: <20090422225203.16081.94717.stgit@bluto.andrew>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version three of my patch to add PCIe ECRC support

Changelog:

v2
Fixed copyright year typo.
Removed unneeded EXPORT_SYMBOL_GPL.
Use pci=ecrc=<option> instead of pcie_ecrc=<option>.
Use "bios" instead of "default" to indicate ECRC should be set by firmware.
Use CONFIG_PCIE_ECRC instead of CONFIG_PCIEECRC.

v3
ECRC setttings changes are now done in the aer_enable_rootport()
routine, so after _OSC is granted.
Moved ecrc.c file from drivers/pci/pcie to drivers/pci/pcie/aer
PCIE_ECRC is now dependent on PCIEAER

 Documentation/kernel-parameters.txt |    6 ++
 drivers/pci/pci.c                   |    2 +
 drivers/pci/pcie/aer/Kconfig        |   13 +++
 drivers/pci/pcie/aer/Makefile       |    2 +
 drivers/pci/pcie/aer/aerdrv_core.c  |   16 ++--
 drivers/pci/pcie/aer/ecrc.c         |  131 +++++++++++++++++++++++++++++++++++
 include/linux/pci.h                 |   11 +++
 7 files changed, 174 insertions(+), 7 deletions(-)
 create mode 100644 drivers/pci/pcie/aer/ecrc.c


-- 
Andrew Patterson

