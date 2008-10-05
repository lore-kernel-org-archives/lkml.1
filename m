Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYJEQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYJEQie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYJEQg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:36:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35287 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761235AbYJEQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:25 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 05/19] aic7xxx: MHz not Mhz for SI unit pedants
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:36:25 +0100
Message-ID: <20081005163613.3799.70131.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closes bug #6422

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 55508b0..e241a93 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -4136,7 +4136,7 @@ ahd_update_neg_table(struct ahd_softc *ahd, struct ahd_devinfo *devinfo,
 
 			/*
 			 * Harpoon2A assumed that there would be a
-			 * fallback rate between 160MHz and 80Mhz,
+			 * fallback rate between 160MHz and 80MHz,
 			 * so 7 is used as the period factor rather
 			 * than 8 for 160MHz.
 			 */
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index c25b6ad..2eb99c8 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -223,10 +223,10 @@ static const char *pci_bus_modes[] =
 	"PCI bus mode unknown",
 	"PCI bus mode unknown",
 	"PCI bus mode unknown",
-	"PCI-X 101-133Mhz",
-	"PCI-X 67-100Mhz",
-	"PCI-X 50-66Mhz",
-	"PCI 33 or 66Mhz"
+	"PCI-X 101-133MHz",
+	"PCI-X 67-100MHz",
+	"PCI-X 50-66MHz",
+	"PCI 33 or 66MHz"
 };
 
 #define		TESTMODE	0x00000800ul

