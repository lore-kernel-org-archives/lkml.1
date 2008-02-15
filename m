Return-Path: <linux-kernel-owner+w=401wt.eu-S935202AbYBOApr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202AbYBOApr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932423AbYBOAmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934751AbYBOAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH 07/12] PCI Hotplug: the ibm driver is not dependant on PCI_LEGACY
Date: Thu, 14 Feb 2008 16:40:05 -0800
Message-Id: <1203036010-27988-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was marked incorrectly for some reason.  Allow the ibmphp driver to
be built even if PCI_LEGACY is not enabled.

Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 17fb3d6..eacfb13 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -63,7 +63,7 @@ config HOTPLUG_PCI_COMPAQ_NVRAM
 
 config HOTPLUG_PCI_IBM
 	tristate "IBM PCI Hotplug driver"
-	depends on X86_IO_APIC && X86 && PCI_BIOS && PCI_LEGACY
+	depends on X86_IO_APIC && X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a IBM PCI Hotplug
 	  controller.
-- 
1.5.4

