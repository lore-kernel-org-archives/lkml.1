Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbXFCOrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbXFCOrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbXFCOnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:43:04 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:37648 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757207AbXFCOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:43:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FLh16tInK9wicn6nfh0mTSdNmUabq1EK9nz9eHCaaAHBmDQDXN0efE8Hgg56kiuqa5z5QuhyrVig7wujTVNn00zGE6Ru7c52/+A0Ly29pJOBwSX/E2E+Wgil1Yqfl9mwi/vFwx1CMPFVWsHuemyoQYWMnxc6R3gfnkwq2pcCdd4=;
X-YMail-OSG: K3gZbxgVM1l7siqHrq203SUdr57qBZPfPiFJiJDZ1tbX2jm.6w2jP9R_4cJqD95cVUd8yw--
Date: Sun, 3 Jun 2007 07:43:00 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 24/36] drivers edac Lindent i5000 driver
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <748226.47850.qm@web50110.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Run e752x_edac.c file through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
---
 i5000_edac.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.22-rc1/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.22-rc1/drivers/edac/i5000_edac.c
@@ -967,7 +967,7 @@ static void calculate_dimm_size(struct i
 	mem_buffer = p = kmalloc(space, GFP_KERNEL);
 	if (p == NULL) {
 		i5000_printk(KERN_ERR, "MC: %s:%s() kmalloc() failed\n",
-			    __FILE__, __func__);
+			     __FILE__, __func__);
 		return;
 	}
 
@@ -1287,13 +1287,13 @@ static int i5000_probe1(struct pci_dev *
 		return -ENODEV;
 
 	/* make sure error reporting method is sane */
-	switch(edac_op_state) {
-		case EDAC_OPSTATE_POLL:
-		case EDAC_OPSTATE_NMI:
-			break;
-		default:
-			edac_op_state = EDAC_OPSTATE_POLL;
-			break;
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
 	}
 
 	/* Ask the devices for the number of CSROWS and CHANNELS so

