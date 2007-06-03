Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbXFCOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbXFCOk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXFCOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:39:38 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:23506 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753612AbXFCOjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:39:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tk6LB/gLuVxtozzJJ1rvx5+Bi0YiVVY/kdUJsO2HZe3zmiyx7bT0FuIsNxdfY16Zh7uGHtlpvvOnvrpvGjmg8QQ99cC8jkgdX84q+/udS+f7C9b0NNCRbez01ovBM4f9jp9Ut/I1mM3JNnqBNyTzzZjSng/X6qEKjsNB0+6RhII=;
X-YMail-OSG: ER3ZodcVM1kID_S_fi2ueRefjhMlO9bkJM_xK1V7V3y9mWFjjChOAp1govyk9uIHdwFC2FUgsad73LDboAApqWH_Fi_wM3XxIeaZDm.Wp04GIUcZUFsUsMbHvDl0Izf08.LrcK3RiQ--
Date: Sun, 3 Jun 2007 07:39:35 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 4/36] drivers edac add new RDDR2 memory type
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <301918.82511.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Thompson <dougthompson@xmission.com>

Add Registered RDDR2 memory types for displaying DDR2 memories



Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 k8_edac.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.20-rc3-mm1/drivers/edac/edac_mc.h
===================================================================
--- linux-2.6.20-rc3-mm1.orig/drivers/edac/edac_mc.h
+++ linux-2.6.20-rc3-mm1/drivers/edac/edac_mc.h
@@ -126,6 +126,7 @@ enum mem_type {
 	MEM_RMBS,		/* Rambus DRAM */
 	MEM_DDR2,               /* DDR2 RAM */
 	MEM_FB_DDR2,            /* fully buffered DDR2 */
+	MEM_RDDR2,              /* Registered DDR2 RAM */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -141,6 +142,7 @@ enum mem_type {
 #define MEM_FLAG_RMBS		BIT(MEM_RMBS)
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
+#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {

