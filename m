Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXLTBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXLTBka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758960AbXLTBfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbXLTBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fs+5i5RjBl3dtkk/p8iPWPhWVx9XmnpncD8vwEosPD9o8pb1jI1feOEroka5XzuBiZsMEIm7ItfrsIVjMcVi/tbhe4iiCTWtqy0eWtJH7HuN6MtWHdSY/nhs1WMh3uO1F7R+lluOXmSZlt/Ik1WLTHVadlvObD+L13yQ12aPHnw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 19/63] ide-cd: remove unused struct atapi_cdrom_subchnl
Date: Thu, 20 Dec 2007 02:06:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200206.39408.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.h |   32 --------------------------------
 1 file changed, 32 deletions(-)

Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -145,38 +145,6 @@ struct atapi_toc {
 	  /* One extra for the leadout. */
 };
 
-
-/* This structure is annoyingly close to, but not identical with,
-   the cdrom_subchnl structure from cdrom.h. */
-struct atapi_cdrom_subchnl {
- 	u_char  acdsc_reserved;
- 	u_char  acdsc_audiostatus;
- 	u_short acdsc_length;
-	u_char  acdsc_format;
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u_char  acdsc_ctrl:     4;
-	u_char  acdsc_adr:      4;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u_char  acdsc_adr:	4;
-	u_char  acdsc_ctrl:	4;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	u_char  acdsc_trk;
-	u_char  acdsc_ind;
-	union {
-		struct atapi_msf msf;
-		int	lba;
-	} acdsc_absaddr;
-	union {
-		struct atapi_msf msf;
-		int	lba;
-	} acdsc_reladdr;
-};
-
-
-
 /* This should probably go into cdrom.h along with the other
  * generic stuff now in the Mt. Fuji spec.
  */
