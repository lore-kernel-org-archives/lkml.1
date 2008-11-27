Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYK0Kwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYK0Kwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYK0Kdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:54 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46030 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYK0KcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:25 -0500
Message-Id: <20081127103136.442737065@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 31/60] cio: update sac values
Content-Disposition: inline; filename=130-cio-fcx.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Values for the sac field have changed - update code accordingly.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/fcx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/include/asm/fcx.h
===================================================================
--- quilt-2.6.orig/arch/s390/include/asm/fcx.h
+++ quilt-2.6/arch/s390/include/asm/fcx.h
@@ -248,8 +248,8 @@ struct dcw {
 #define TCCB_MAX_SIZE		(sizeof(struct tccb_tcah) + \
 				 TCCB_MAX_DCW * sizeof(struct dcw) + \
 				 sizeof(struct tccb_tcat))
-#define TCCB_SAC_DEFAULT	0xf901
-#define TCCB_SAC_INTRG		0xf902
+#define TCCB_SAC_DEFAULT	0x1ffe
+#define TCCB_SAC_INTRG		0x1fff
 
 /**
  * struct tccb_tcah - Transport-Command-Area Header (TCAH)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

