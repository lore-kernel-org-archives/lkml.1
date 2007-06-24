Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXFXMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXFXMST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXFXMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:18:10 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:57640 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbXFXMSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:18:08 -0400
From: Chr <chunkeey@web.de>
To: linux-ide@vger.kernel.org
Subject: [PATCH] libata: adding ICH8M PCIIDs to ATA_PIIX.
Date: Sun, 24 Jun 2007 14:18:05 +0200
User-Agent: KMail/1.9.7
Cc: "Gaston, Jason D" <jason.d.gaston@intel.com>,
       Jeff Garzik <jeff@garzik.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, chunkeey@web.de
References: <39B20DF628532344BC7A2692CB6AEE07016FE51B@orsmsx420.amr.corp.intel.com> <4676E15C.80300@garzik.org>
In-Reply-To: <4676E15C.80300@garzik.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9DmfGHLZhnHm8oq"
Message-Id: <200706241418.05694.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX181xQRcvcvoy6TF7i164A5UMsW35nZHuqb3RkgF
	aqbqF4lmhHIrP84GSxlTxTz+FtsUmOJGXu81y2KuLnPcI1aNhZ
	bIVzQo6uk=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9DmfGHLZhnHm8oq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 18. June 2007, Jeff Garzik wrote:
> Gaston, Jason D wrote:
> > I don't think we want to have the same DeviceID supported in more then one driver.  Would they not conflict with each other?
> 
> In Fedora 7, CONFIG_IDE is disabled.  ata_piix drives all hardware at 
> that point.
> 
> 	Jeff


Hmm, did I forgot anything important in the last mail, or is everyone just busy?
(please keep CC!)

---
This patch adds a necessary PCIID for Santa Rosa's PATA controller.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
 drivers/ata/ata_piix.c |    2 ++
 1 file changed, 2 insertions(+)



--Boundary-00=_9DmfGHLZhnHm8oq
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="ich8m-add-pciid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ich8m-add-pciid.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9c07b88..b210726 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -200,6 +200,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH7/7-R (i945, i975) UDMA 100*/
 	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	/* ICH8 Mobile PATA Controller */
+	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
 
 	/* NOTE: The following PCI ids must be kept in sync with the
 	 * list in drivers/pci/quirks.c.

--Boundary-00=_9DmfGHLZhnHm8oq--
