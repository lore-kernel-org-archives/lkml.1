Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZFKSpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZFKSpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbZFKSpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:45:23 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:51978 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZFKSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=cE7bdKF1aDWbTHYI1RqLJtsp/DCEqT2kIf9WgyP25vXDBjL7/Azt3qZKeYmzP3dPLS
         p9Qc6N2T6AMWCiwTjXjL4Fdqig4vEFdicnQjVgknRnfQUNoKnAN0iG408RQKHzJqyRTA
         BVyRlCQIx8fYttvyeaB5mkblVzhj3UQxAztlY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH staging] Staging: rt28[67]0: remove unused md4.h
Date: Thu, 11 Jun 2009 20:12:19 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906112012.19830.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against next-20090611

 drivers/staging/rt2860/md4.h |   42 ------------------------------------------
 drivers/staging/rt2870/md4.h |   42 ------------------------------------------
 2 files changed, 84 deletions(-)

Index: b/drivers/staging/rt2860/md4.h
===================================================================
--- a/drivers/staging/rt2860/md4.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- *************************************************************************
- * Ralink Tech Inc.
- * 5F., No.36, Taiyuan St., Jhubei City,
- * Hsinchu County 302,
- * Taiwan, R.O.C.
- *
- * (c) Copyright 2002-2007, Ralink Technology, Inc.
- *
- * This program is free software; you can redistribute it and/or modify  *
- * it under the terms of the GNU General Public License as published by  *
- * the Free Software Foundation; either version 2 of the License, or     *
- * (at your option) any later version.                                   *
- *                                                                       *
- * This program is distributed in the hope that it will be useful,       *
- * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- * GNU General Public License for more details.                          *
- *                                                                       *
- * You should have received a copy of the GNU General Public License     *
- * along with this program; if not, write to the                         *
- * Free Software Foundation, Inc.,                                       *
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- *                                                                       *
- *************************************************************************
- */
-
-#ifndef __MD4_H__
-#define __MD4_H__
-
-/* MD4 context. */
-typedef	struct	_MD4_CTX_	{
-	ULONG	state[4];        /* state (ABCD) */
-	ULONG	count[2];        /* number of bits, modulo 2^64 (lsb first) */
-	UCHAR	buffer[64];      /* input buffer */
-}	MD4_CTX;
-
-VOID MD4Init (MD4_CTX *);
-VOID MD4Update (MD4_CTX *, PUCHAR, UINT);
-VOID MD4Final (UCHAR [16], MD4_CTX *);
-
-#endif //__MD4_H__
\ No newline at end of file
Index: b/drivers/staging/rt2870/md4.h
===================================================================
--- a/drivers/staging/rt2870/md4.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- *************************************************************************
- * Ralink Tech Inc.
- * 5F., No.36, Taiyuan St., Jhubei City,
- * Hsinchu County 302,
- * Taiwan, R.O.C.
- *
- * (c) Copyright 2002-2007, Ralink Technology, Inc.
- *
- * This program is free software; you can redistribute it and/or modify  *
- * it under the terms of the GNU General Public License as published by  *
- * the Free Software Foundation; either version 2 of the License, or     *
- * (at your option) any later version.                                   *
- *                                                                       *
- * This program is distributed in the hope that it will be useful,       *
- * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- * GNU General Public License for more details.                          *
- *                                                                       *
- * You should have received a copy of the GNU General Public License     *
- * along with this program; if not, write to the                         *
- * Free Software Foundation, Inc.,                                       *
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- *                                                                       *
- *************************************************************************
- */
-
-#ifndef __MD4_H__
-#define __MD4_H__
-
-/* MD4 context. */
-typedef	struct	_MD4_CTX_	{
-	ULONG	state[4];        /* state (ABCD) */
-	ULONG	count[2];        /* number of bits, modulo 2^64 (lsb first) */
-	UCHAR	buffer[64];      /* input buffer */
-}	MD4_CTX;
-
-VOID MD4Init (MD4_CTX *);
-VOID MD4Update (MD4_CTX *, PUCHAR, UINT);
-VOID MD4Final (UCHAR [16], MD4_CTX *);
-
-#endif //__MD4_H__
\ No newline at end of file
