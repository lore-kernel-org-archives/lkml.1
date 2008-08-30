Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYH3Usk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYH3Usk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYH3Usc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:48:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:30895 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYH3Usb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EUIruLa7U2EHEdVqdpNmSg5clEhKk0LwQDKClVfXcue/pH0303QI/V3CjqMnDP4fcX
         +CBfSSTJu2sOtMc2B+jtv3m6kXxA+tmswe4mXFIREih/S/8NzXFzCft1BJuwzIjKL4oh
         VwILdciJ3qea9vHHXHCULbwkKkdh+MCfBIBsc=
Message-ID: <48B9B218.6060506@gmail.com>
Date: Sat, 30 Aug 2008 22:48:24 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: david@gibson.dropbear.id.au, benh@kernel.crashing.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ibm_newemac: MAL[12]_IER_EVENTS definition: 2x *_OTE -> *_DE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAL[12]_IER_EVENTS definitions have MAL_IER_OTE twice
but lack MAL_IER_DE

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/ibm_newemac/mal.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ibm_newemac/mal.h b/drivers/net/ibm_newemac/mal.h
index eaa7262..717dc38 100644
--- a/drivers/net/ibm_newemac/mal.h
+++ b/drivers/net/ibm_newemac/mal.h
@@ -102,7 +102,7 @@
 /* MAL V1 IER bits */
 #define   MAL1_IER_NWE		0x00000008
 #define   MAL1_IER_SOC_EVENTS	MAL1_IER_NWE
-#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_OTE | \
+#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_DE | \
 				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
 /* MAL V2 IER bits */
@@ -110,7 +110,7 @@
 #define   MAL2_IER_PRE		0x00000040
 #define   MAL2_IER_PWE		0x00000020
 #define   MAL2_IER_SOC_EVENTS	(MAL2_IER_PT | MAL2_IER_PRE | MAL2_IER_PWE)
-#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_OTE | \
+#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_DE | \
 				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
 
