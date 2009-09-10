Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZIJSdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZIJSdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZIJSdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:33:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40954 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZIJSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:33:50 -0400
Subject: [PATCH v2 0/2] PCI Hotplug: internal interface cleanups
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Sep 2009 12:33:58 -0600
Message-ID: <20090910183219.20011.41679.stgit@bob.kio>
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

v1 -> v2:
	- incorporated Kenji-san's comments

---

Alex Chiang (2):
      PCI Hotplug: acpiphp: find bridges the easy way
      PCI Hotplug: convert acpi_pci_detect_ejectable() to take an acpi_handle


 drivers/pci/hotplug/acpi_pcihp.c   |   12 ++--
 drivers/pci/hotplug/acpiphp_glue.c |  104 +++++++++---------------------------
 drivers/pci/hotplug/pciehp_acpi.c  |    7 +-
 include/linux/pci_hotplug.h        |    2 -
 4 files changed, 38 insertions(+), 87 deletions(-)

