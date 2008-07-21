Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYGUQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYGUQdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYGUQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:33:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53400 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYGUQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:33:11 -0400
Date: Mon, 21 Jul 2008 09:27:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: [PATCH] pci kernel-doc fatal error
Message-Id: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc comments so that they don't produce errors.
Also cut some extraneous copy-paste text.

Error(linhead//drivers/pci/pci.c:1133): duplicate section name 'Description'
Error(linhead//drivers/pci/pci.c:1189): duplicate section name 'Description'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/pci.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linhead.orig/drivers/pci/pci.c
+++ linhead/drivers/pci/pci.c
@@ -1123,8 +1123,7 @@ int pci_enable_wake(struct pci_dev *dev,
 }
 
 /**
- * pci_prepare_to_sleep - prepare PCI device for system-wide transition into
- *                        a sleep state
+ * pci_prepare_to_sleep - prepare PCI device for system-wide transition into a sleep state
  * @dev: Device to handle.
  *
  * Choose the power state appropriate for the device depending on whether
@@ -1181,8 +1180,7 @@ int pci_prepare_to_sleep(struct pci_dev 
 }
 
 /**
- * pci_back_from_sleep - turn PCI device on during system-wide transition into
- *                       the working state a sleep state
+ * pci_back_from_sleep - turn PCI device on during system-wide transition into working state
  * @dev: Device to handle.
  *
  * Disable device's sytem wake-up capability and put it into D0.
