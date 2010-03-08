Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0CHUDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:03:13 -0500
Received: from n12.bullet.mail.mud.yahoo.com ([209.191.125.209]:32957 "HELO
	n12.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751136Ab0CHUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:03:01 -0500
X-Yahoo-Newman-Id: 4936.66007.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=UZD5il2HQKIoia7LWzNdefEgOYi7r3gCi55y0bNEQKSBge8PQO9x/RC+9xlZj13gnwbpUBWC8XQEEbd120ec4OkkZbIxHranQUEM0uGQxSnufLbgecuuT5zsDXAgloSl5k+YqkrapNxGE3bvXv1Ku8rnaoFOHozf67Ms/2YF9hk=  ;
X-Yahoo-SMTP: IhX6ZViswBC.oHmHTpK.38RDjYXQA.U2QFg-
X-YMail-OSG: lEBwjPIVM1kLNfWPimUs4GOx3L0LW15a1tshWgsvfVRZqDL6cLPdYdQjFFCFYaIjppg5ffCdRvDj.k2Mbonji886LN8EDfuxfCrSLdOwv5TwEsSBOKvFz.oZsAsDboPe3WMS2sGnSl_uWbzPykjXBpGc0SY85mY4VZGvKjW9trDWrQeeGGQlPy2V4nVJQMoyJ959hwr20ju9Ssn38fqGMQ6w__PZcGib1r13LiWVDEHz0xyN57jBkL.4_qmxGUXKFLNtllfeFrk4i5a1iav.HlswwjF85urFnXIYAnWzGjq1OuWDpy5Wyk6TCPNL1vZn5_XqqlMc4vEaXtsYebhk8oYUe01bqA--
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 1/2] Staging: rar: fixed various style issues in
 rar_driver.c
From: Eric Anschuetz <ericanschuetz@yahoo.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 15:02:59 -0500
Message-ID: <1268078579.4345.1.camel@Acer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e328efd2312d1c010e242c848b23ff1195028686 Mon Sep 17 00:00:00 2001
From: Eric Anschuetz <gh4ever@Acer-laptop.(none)>
Date: Sun, 7 Mar 2010 16:03:22 -0500
Subject: [PATCH 1/2] Staging: rar: fixed various style issues in rar_driver.c
 This is a patch to the rar_driver.c file that fixes indentation and space issues found by the checkpatch.pl tool.
 Signed-off-by: Eric Anschuetz <ericanschuetz@yahoo.com>

---
 drivers/staging/rar/rar_driver.c |   62 +++++++++++++++++++-------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index d85d189..640b06f 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -86,9 +86,9 @@ static struct pci_driver rar_pci_driver = {
 
 /* This function is used to retrieved RAR info using the IPC message
    bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
+static int memrar_get_rar_addr(struct pci_dev *pdev,
+				int offset,
+				u32 *addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -140,23 +140,23 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev,
-	                          LNC_MCR_OFFSET,
-	                          message);
+				LNC_MCR_OFFSET,
+				message);
 
 	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	  , result);
 
 	if (!result)
 		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
+						LNC_MDR_OFFSET,
+						addr);
 
 	printk(KERN_WARNING "rar- result from read data register is %x\n",
 	  result);
@@ -170,9 +170,9 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 		return 0;
 }
 
-static int memrar_set_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 addr)
+static int memrar_set_rar_addr(struct pci_dev *pdev,
+				int offset,
+				u32 addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -225,23 +225,23 @@ static int memrar_set_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev,
-	                          LNC_MDR_OFFSET,
-	                          addr);
+				LNC_MDR_OFFSET,
+				addr);
 
 	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	  , result);
 
 	if (!result)
 		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
+						LNC_MCR_OFFSET,
+						message);
 
 	printk(KERN_WARNING "rar- result from write data register is %x\n",
 	  result);
@@ -284,15 +284,15 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
 
 	if (pdev == NULL)
-	       return -ENODEV;
+		return -ENODEV;
 
 	for (i = offsets; i != end; ++i, ++n) {
-	       if (memrar_get_rar_addr (pdev,
-		                       (*i).low,
-		                       &(rar_addr[n].low)) != 0
-		   || memrar_get_rar_addr (pdev,
-		                          (*i).high,
-		                          &(rar_addr[n].high)) != 0) {
+		if (memrar_get_rar_addr(pdev,
+					(*i).low,
+					&(rar_addr[n].low)) != 0
+			|| memrar_get_rar_addr(pdev,
+					(*i).high,
+					&(rar_addr[n].high)) != 0) {
 		       result = -1;
 		       break;
 	       }
@@ -302,7 +302,7 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	/* pci_dev_put(pdev); */
 
 	if (result == 0) {
-	if(1) {
+	if (1) {
 	       size_t z;
 	       for (z = 0; z != MRST_NUM_RAR; ++z) {
 			printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
@@ -347,7 +347,7 @@ static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Initialize the RAR parameters, which have to be retrieved */
 	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
+	error = memrar_init_rar_params(rar_dev);
 
 	if (error) {
 		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
@@ -396,10 +396,10 @@ MODULE_LICENSE("GPL");
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
+int get_rar_address(int rar_index, struct RAR_address_struct *addresses)
 {
 	if (registered && (rar_index < 3) && (rar_index >= 0)) {
-		*addresses=rar_addr[rar_index];
+		*addresses = rar_addr[rar_index];
 		/* strip off lock bit information  */
 		addresses->low = addresses->low & 0xfffffff0;
 		addresses->high = addresses->high & 0xfffffff0;
@@ -431,10 +431,10 @@ int lock_rar(int rar_index)
 	int result;
 if (registered && (rar_index < 3) && (rar_index >= 0)) {
 	/* first make sure that lock bits are clear (this does lock) */
-	working_addr=rar_addr[rar_index].low & 0xfffffff0;
+	working_addr = rar_addr[rar_index].low & 0xfffffff0;
 
 	/* now send that value to the register using the IPC */
-        result=memrar_set_rar_addr(rar_dev,rar_index,working_addr);
+	result = memrar_set_rar_addr(rar_dev, rar_index, working_addr);
 	return result;
 	}
 
-- 
1.6.3.3





