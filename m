Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYLIUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYLIUth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYLIUt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:49:27 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:47415 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYLIUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=EuadbUxmtXCAkdJrneC/LeBjq698gV8lZ6pBaFf/RLjbGJHAN68CykeTXmIksZvRn4
         6B/H1piqQT2Dll+UllPDrAtthzlJ44ykYO9TGb9zB9RL/EN670oTr+3n12sX1j9sElyP
         /EfdvMkRqyqnwyF1ECkp643Pq0t4RpP1fNcSs=
Message-ID: <493ED9D4.5000508@gmail.com>
Date: Tue, 09 Dec 2008 21:49:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/31] drivers/pci: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/pci/hotplug/ibmphp_hpc.c |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c |    2 +-
 drivers/pci/pci-driver.c         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_hpc.c b/drivers/pci/hotplug/ibmphp_hpc.c
index 83f337c..5c0dbc4 100644
--- a/drivers/pci/hotplug/ibmphp_hpc.c
+++ b/drivers/pci/hotplug/ibmphp_hpc.c
@@ -782,7 +782,7 @@ static void get_hpc_access (void)
 /*----------------------------------------------------------------------
 * Name:    free_hpc_access()
 *---------------------------------------------------------------------*/
-void free_hpc_access (void)
+static void free_hpc_access(void)
 {
 	mutex_unlock(&sem_hpcaccess);
 }
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index b643ca1..e23cfc1 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1254,7 +1254,7 @@ abort:
 	return NULL;
 }
 
-void pcie_release_ctrl(struct controller *ctrl)
+static void pcie_release_ctrl(struct controller *ctrl)
 {
 	pcie_shutdown_notification(ctrl);
 	pcie_cleanup_slot(ctrl);
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..28eb38d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -654,7 +654,7 @@ static int pci_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
-struct pm_ext_ops pci_pm_ops = {
+static struct pm_ext_ops pci_pm_ops = {
 	.base = {
 		.prepare = pci_pm_prepare,
 		.complete = pci_pm_complete,

