Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZJ3Tq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZJ3Tq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZJ3Tqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:46:55 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:36726
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbZJ3Tqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:46:55 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Alex Chiang <achiang@hp.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pci: remove pci_find_slot from PCI_LEGACY config description
Date: Fri, 30 Oct 2009 17:46:48 -0200
Message-Id: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3b073eda has removed pci_find_slot, so there's no point in
mentioning it in the config description as one of the deprecated APIs
there are enabled by PCI_LEGACY and still used by some drivers.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/pci/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index fdc864f..48a3ea7 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -27,10 +27,10 @@ config PCI_LEGACY
 	default y
 	help
 	  Say Y here if you want to include support for the deprecated
-	  pci_find_slot() and pci_find_device() APIs.  Most drivers have
-	  been converted over to using the proper hotplug APIs, so this
-	  option serves to include/exclude only a few drivers that are
-	  still using this API.
+	  pci_find_device() API.  Most drivers have been converted over
+	  to using the proper hotplug APIs, so this option serves to
+	  include/exclude only a few drivers that are still using this
+	  API.
 
 config PCI_DEBUG
 	bool "PCI Debugging"
-- 
1.6.3.3

