Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYGWSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYGWSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYGWSug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:50:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbYGWSu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=sIWSl/PHLk5TmV52mol1GXlWWcxAigMlY8gXBrv0zcxVrh8m6OFSm7bq7IwmL/lRn9
         Rng18szuwrkXxZS9Rhni5E6cYLgI/vcHD5od6ybyb4mZhZ0D5Ki/kAmOxiUPYqXxtlNK
         h9Vt5CV3leXXXkV5zemV4ittg/LhuQAgkdmQs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 7/7] include/linux/hdreg.h: cover WIN_* and friends with #ifndef/#endif __KERNEL__
Date: Wed, 23 Jul 2008 20:46:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807232046.08991.bzolnier@gmail.com>
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
@@ -191,6 +191,7 @@ typedef struct hd_drive_hob_hdr {
 #define TASKFILE_INVALID		0x7fff
 #endif
 
+#ifndef __KERNEL__
 /* ATA/ATAPI Commands pre T13 Spec */
 #define WIN_NOP				0x00
 /*
@@ -379,6 +380,7 @@ typedef struct hd_drive_hob_hdr {
 #define SECURITY_ERASE_UNIT		0xBD
 #define SECURITY_FREEZE_LOCK		0xBE
 #define SECURITY_DISABLE_PASSWORD	0xBF
+#endif /* __KERNEL__ */
 
 struct hd_geometry {
       unsigned char heads;
