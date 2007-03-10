Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbXCJVgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbXCJVgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXCJVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:36:51 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49802 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbXCJVgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:36:50 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:34:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, airlied@linux.ie
Subject: [PATCH] DRM: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101632200.28013@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete apparently unused header file drivers/char/drm/via_mm.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/char/drm/via_mm.h b/drivers/char/drm/via_mm.h
deleted file mode 100644
index d57efda..0000000
--- a/drivers/char/drm/via_mm.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright 1998-2003 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2003 S3 Graphics, Inc. All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sub license,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the
- * next paragraph) shall be included in all copies or substantial portions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
- * VIA, S3 GRAPHICS, AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- */
-#ifndef _via_drm_mm_h_
-#define _via_drm_mm_h_
-
-typedef struct {
-	unsigned int context;
-	unsigned int size;
-	unsigned long offset;
-	unsigned long free;
-} drm_via_mm_t;
-
-typedef struct {
-	unsigned int size;
-	unsigned long handle;
-	void *virtual;
-} drm_via_dma_t;
-
-#endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
