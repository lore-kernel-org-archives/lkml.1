Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYFCRGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYFCRGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYFCRFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:05:49 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:10458 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYFCRFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:05:47 -0400
Message-Id: <20080603170520.017934731@de.ibm.com>
References: <20080603165859.107949986@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 18:59:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/14] cio: introduce fcx bit to chsc characteristics
Content-Disposition: inline; filename=106-fcx-chsc.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Introduce fcx bit to chsc characteristics.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/chsc.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chsc.h
+++ quilt-2.6/drivers/s390/cio/chsc.h
@@ -49,7 +49,9 @@ struct css_general_char {
 	u32 qebsm : 1;   /* bit 58 */
 	u32 : 8;
 	u32 aif_osa : 1; /* bit 67 */
-	u32 : 28;
+	u32 : 20;
+	u32 fcx : 1;	 /* bit 88 */
+	u32 : 7;
 }__attribute__((packed));
 
 struct css_chsc_char {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

