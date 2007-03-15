Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbXCOWYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbXCOWYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXCOWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:27 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33704 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 33] IB/ipath - definitions of two of RXE parity error
	bits were reversed
X-Mercurial-Node: e2eec96f356a7269b46a68f29fc5e711d2f5a7a4
Message-Id: <e2eec96f356a7269b46a.1173995087@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:47 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994464 25200
# Node ID e2eec96f356a7269b46a68f29fc5e711d2f5a7a4
# Parent  3337d450afeebc553a09fe5c18ed0b2444547c24
IB/ipath - definitions of two of RXE parity error bits were reversed

The chip documentation on the expected TID vs eager TID parity error
bits was reversed from what was implemented in the RTL, for both chips.
This corrects the definitions.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 3337d450afee -r e2eec96f356a drivers/infiniband/hw/ipath/ipath_registers.h
--- a/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_registers.h	Thu Mar 15 14:34:24 2007 -0700
@@ -128,7 +128,7 @@
 
 /* kr_hwerrclear, kr_hwerrmask, kr_hwerrstatus, bits */
 /* TXEMEMPARITYERR bit 0: PIObuf, 1: PIOpbc, 2: launchfifo
- * RXEMEMPARITYERR bit 0: rcvbuf, 1: lookupq, 2: eagerTID, 3: expTID
+ * RXEMEMPARITYERR bit 0: rcvbuf, 1: lookupq, 2:  expTID, 3: eagerTID
  * 		bit 4: flag buffer, 5: datainfo, 6: header info */
 #define INFINIPATH_HWE_TXEMEMPARITYERR_MASK 0xFULL
 #define INFINIPATH_HWE_TXEMEMPARITYERR_SHIFT 40
@@ -143,8 +143,8 @@
 /* rxe mem parity errors (shift by INFINIPATH_HWE_RXEMEMPARITYERR_SHIFT) */
 #define INFINIPATH_HWE_RXEMEMPARITYERR_RCVBUF   0x01ULL
 #define INFINIPATH_HWE_RXEMEMPARITYERR_LOOKUPQ  0x02ULL
-#define INFINIPATH_HWE_RXEMEMPARITYERR_EAGERTID 0x04ULL
-#define INFINIPATH_HWE_RXEMEMPARITYERR_EXPTID   0x08ULL
+#define INFINIPATH_HWE_RXEMEMPARITYERR_EXPTID   0x04ULL
+#define INFINIPATH_HWE_RXEMEMPARITYERR_EAGERTID 0x08ULL
 #define INFINIPATH_HWE_RXEMEMPARITYERR_FLAGBUF  0x10ULL
 #define INFINIPATH_HWE_RXEMEMPARITYERR_DATAINFO 0x20ULL
 #define INFINIPATH_HWE_RXEMEMPARITYERR_HDRINFO  0x40ULL
