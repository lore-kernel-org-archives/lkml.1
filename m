Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810Ab0A0AGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0A0AGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752Ab0A0AGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:06:22 -0500
Received: from kroah.org ([198.145.64.141]:35086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab0AZXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.762127558@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <Eric.moore@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [07/98] [SCSI] mpt2sas: New device SAS2208 support is added
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit db27136a89d061bf9dceb28953a61a8ef862ca7f upstream.

Added device ids range for { 0x80 - 87 } , modified mpi/mpi2_cnfg.h containing
MPI2_MFGPAGE_DEVID_SAS2208_X.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h |    8 ++++++++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -348,6 +348,14 @@ typedef struct _MPI2_CONFIG_REPLY
 #define MPI2_MFGPAGE_DEVID_SAS2108_3                (0x0077)
 #define MPI2_MFGPAGE_DEVID_SAS2116_1                (0x0064)
 #define MPI2_MFGPAGE_DEVID_SAS2116_2                (0x0065)
+#define MPI2_MFGPAGE_DEVID_SAS2208_1                (0x0080)
+#define MPI2_MFGPAGE_DEVID_SAS2208_2                (0x0081)
+#define MPI2_MFGPAGE_DEVID_SAS2208_3                (0x0082)
+#define MPI2_MFGPAGE_DEVID_SAS2208_4                (0x0083)
+#define MPI2_MFGPAGE_DEVID_SAS2208_5                (0x0084)
+#define MPI2_MFGPAGE_DEVID_SAS2208_6                (0x0085)
+#define MPI2_MFGPAGE_DEVID_SAS2208_7                (0x0086)
+#define MPI2_MFGPAGE_DEVID_SAS2208_8                (0x0087)
 
 
 /* Manufacturing Page 0 */
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -196,10 +196,28 @@ static struct pci_device_id scsih_pci_ta
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
 		PCI_ANY_ID, PCI_ANY_ID },
+	/* Meteor ~ 2116 */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2116_1,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2116_2,
 		PCI_ANY_ID, PCI_ANY_ID },
+	/* Thunderbolt ~ 2208 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_3,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_4,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_5,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_6,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_7,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_8,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, scsih_pci_table);


