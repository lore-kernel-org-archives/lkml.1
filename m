Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0CHUGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:06:06 -0500
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:28517 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755582Ab0CHUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:05:57 -0500
X-Yahoo-Newman-Id: 540208.81282.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=UYGDihSmxfDjSyllMfNUYMUQDlAYQDNW5kgF3Zny6CV2M/1fDhpLDjJc/zKOOi+ll8C2keq14hvHIuGUkH28w2v8MWYiSJqMKm4+S/L0FTcwbwfe78o14WbeeCK3UhmwYRRY7/5qf8tWUGKeKNna/EsNVaEF/L30VgqW3Dr1qPw=  ;
X-Yahoo-SMTP: IhX6ZViswBC.oHmHTpK.38RDjYXQA.U2QFg-
X-YMail-OSG: dWgAROIVM1mE5n9SuymLkX8kwB1q.y3QirNcRfvBsg_ibq8M5WsVLp2f11ypS2fM1orGzfryuS.T2T90XfrhgwUdkckNddMWpzbdZwT1b40d_8I8hnWHrzHrecdRFxBOPsCOBaByUy53L7nhgdCi8IrB0rumjvgSpvydQtlMhk2qvcvw5KGxSaK.RCVynoJlZhySY.QnfZdReJSNMqSVHzvGUMVgethpGkmZfwwFeIfxyS4Dz0rZvSF7LVapcIcWw8z8Tnr4ubhZkkOmncNXIOpiQ..R6ToLQ9tQmO6rS73rDNQmkORSu5p3Q6WL
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/2] Staging: rar: fix various style issues in rar_driver.c
From: Eric Anschuetz <ericanschuetz@yahoo.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 15:04:50 -0500
Message-ID: <1268078690.4345.2.camel@Acer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d59ee6e30f056f262948dc35c8c1967c9d1b2a5 Mon Sep 17 00:00:00 2001
From: Eric Anschuetz <gh4ever@Acer-laptop.(none)>
Date: Sun, 7 Mar 2010 16:16:17 -0500
Subject: [PATCH 2/2] Staging: rar: fix various style issues in rar_driver.c
 This is a patch to the rar_driver.c file that fixes indentation and space warnings.
 Signed-off-by: Eric Anschuetz <ericanschuetz@yahoo.com>

---
 drivers/staging/rar/rar_driver.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index 640b06f..e1a7402 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -293,7 +293,7 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 			|| memrar_get_rar_addr(pdev,
 					(*i).high,
 					&(rar_addr[n].high)) != 0) {
-		       result = -1;
+			result = -1;
 		       break;
 	       }
 	}
@@ -302,18 +302,18 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	/* pci_dev_put(pdev); */
 
 	if (result == 0) {
-	if (1) {
-	       size_t z;
-	       for (z = 0; z != MRST_NUM_RAR; ++z) {
-			printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
-			     "\tlow:  0x%08x\n"
-			     "\thigh: 0x%08x\n",
-			     z,
-			     rar_addr[z].low,
-			     rar_addr[z].high);
+		if (1) {
+			size_t z;
+			for (z = 0; z != MRST_NUM_RAR; ++z) {
+				printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
+					"\tlow:  0x%08x\n"
+					"\thigh: 0x%08x\n",
+					z,
+					rar_addr[z].low,
+					rar_addr[z].high);
+				}
 			}
-	       }
-	}
+		}
 
 	return result;
 }
@@ -410,8 +410,6 @@ int get_rar_address(int rar_index, struct RAR_address_struct *addresses)
 		return -ENODEV;
 		}
 }
-
-
 EXPORT_SYMBOL(get_rar_address);
 
 /* The lock_rar function is ued by other device drivers to lock an RAR.
-- 
1.6.3.3





