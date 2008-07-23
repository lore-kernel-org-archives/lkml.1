Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYGWSjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYGWSjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYGWSgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28905 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYGWSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=NV8wUFRIkRRtiOT6is6uPjqYdQlAcaWrygCBSnHAGF/XTo101bwIo7kYpozQjZPsS7
         1vnOuIMKq3L2sMIWwghzYp1q7aOWXOnKIDnZhdN+HjOpCMKy1PkCCcptdI1bF417hbIG
         WK5L/Eu/86uULA5Wp6t3v0Ap3/yGNiLGQJVrA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] include/linux/hdreg.h: cover struct hd_driveid with #ifndef/#endif __KERNEL__
Date: Wed, 23 Jul 2008 20:33:34 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807232033.34894.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/hdreg.h |    2 ++
 1 file changed, 2 insertions(+)

Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -448,6 +448,7 @@ enum {
 
 #define __NEW_HD_DRIVE_ID
 
+#ifndef __KERNEL__
 /*
  * Structure returned by HDIO_GET_IDENTITY, as per ANSI NCITS ATA6 rev.1b spec.
  *
@@ -700,6 +701,7 @@ struct hd_driveid {
 					 *  7:0 Signature
 					 */
 };
+#endif /* __KERNEL__ */
 
 /*
  * IDE "nice" flags. These are used on a per drive basis to determine
