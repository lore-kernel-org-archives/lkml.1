Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZADLsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZADLsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZADLrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:17 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:36107 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZADLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/7] fbdev: c2p - Correct indentation
Date: Sun,  4 Jan 2009 12:47:00 +0100
Message-Id: <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c |  238 ++++++++++++++++++++++++++-------------------------
 1 files changed, 120 insertions(+), 118 deletions(-)

diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
index 376bc07..f102b57 100644
--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -21,71 +21,71 @@
      *  Basic transpose step
      */
 
-#define _transp(d, i1, i2, shift, mask)			\
-    do {						\
-	u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;	\
-	d[i1] ^= t;					\
-	d[i2] ^= t << shift;				\
-    } while (0)
+#define _transp(d, i1, i2, shift, mask)				\
+	do {							\
+		u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;	\
+		d[i1] ^= t;					\
+		d[i2] ^= t << shift;				\
+	} while (0)
 
 static inline u32 get_mask(int n)
 {
-    switch (n) {
+	switch (n) {
 	case 1:
-	    return 0x55555555;
-	    break;
+		return 0x55555555;
+		break;
 
 	case 2:
-	    return 0x33333333;
-	    break;
+		return 0x33333333;
+		break;
 
 	case 4:
-	    return 0x0f0f0f0f;
-	    break;
+		return 0x0f0f0f0f;
+		break;
 
 	case 8:
-	    return 0x00ff00ff;
-	    break;
+		return 0x00ff00ff;
+		break;
 
 	case 16:
-	    return 0x0000ffff;
-	    break;
-    }
-    return 0;
+		return 0x0000ffff;
+		break;
+	}
+	return 0;
 }
 
-#define transp_nx1(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	/* First block */				\
-	_transp(d, 0, 1, n, mask);			\
-	/* Second block */				\
-	_transp(d, 2, 3, n, mask);			\
-	/* Third block */				\
-	_transp(d, 4, 5, n, mask);			\
-	/* Fourth block */				\
-	_transp(d, 6, 7, n, mask);			\
-    } while (0)
-
-#define transp_nx2(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	/* First block */				\
-	_transp(d, 0, 2, n, mask);			\
-	_transp(d, 1, 3, n, mask);			\
-	/* Second block */				\
-	_transp(d, 4, 6, n, mask);			\
-	_transp(d, 5, 7, n, mask);			\
-    } while (0)
-
-#define transp_nx4(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	_transp(d, 0, 4, n, mask);			\
-	_transp(d, 1, 5, n, mask);			\
-	_transp(d, 2, 6, n, mask);			\
-	_transp(d, 3, 7, n, mask);			\
-    } while (0)
+#define transp_nx1(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* First block */				\
+		_transp(d, 0, 1, n, mask);			\
+		/* Second block */				\
+		_transp(d, 2, 3, n, mask);			\
+		/* Third block */				\
+		_transp(d, 4, 5, n, mask);			\
+		/* Fourth block */				\
+		_transp(d, 6, 7, n, mask);			\
+	} while (0)
+
+#define transp_nx2(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* First block */				\
+		_transp(d, 0, 2, n, mask);			\
+		_transp(d, 1, 3, n, mask);			\
+		/* Second block */				\
+		_transp(d, 4, 6, n, mask);			\
+		_transp(d, 5, 7, n, mask);			\
+	} while (0)
+
+#define transp_nx4(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		_transp(d, 0, 4, n, mask);			\
+		_transp(d, 1, 5, n, mask);			\
+		_transp(d, 2, 6, n, mask);			\
+		_transp(d, 3, 7, n, mask);			\
+	} while (0)
 
 #define transp(d, n, m)	transp_nx ## m(d, n)
 
@@ -99,11 +99,11 @@ static inline u32 get_mask(int n)
 
 static void c2p_8bpp(u32 d[8])
 {
-    transp(d, 16, 4);
-    transp(d, 8, 2);
-    transp(d, 4, 1);
-    transp(d, 2, 4);
-    transp(d, 1, 2);
+	transp(d, 16, 4);
+	transp(d, 8, 2);
+	transp(d, 4, 1);
+	transp(d, 2, 4);
+	transp(d, 1, 2);
 }
 
 
@@ -132,10 +132,10 @@ static inline unsigned long comp(unsigned long a, unsigned long b,
 
 static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
 {
-    int i;
+	int i;
 
-    for (i = 0; i < bpp; i++, dst += dst_inc)
-	*(u32 *)dst = d[perm_c2p_8bpp[i]];
+	for (i = 0; i < bpp; i++, dst += dst_inc)
+		*(u32 *)dst = d[perm_c2p_8bpp[i]];
 }
 
 
@@ -146,10 +146,10 @@ static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
 static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
 				       u32 d[8], u32 mask)
 {
-    int i;
+	int i;
 
-    for (i = 0; i < bpp; i++, dst += dst_inc)
-	*(u32 *)dst = comp(d[perm_c2p_8bpp[i]], *(u32 *)dst, mask);
+	for (i = 0; i < bpp; i++, dst += dst_inc)
+		*(u32 *)dst = comp(d[perm_c2p_8bpp[i]], *(u32 *)dst, mask);
 }
 
 
@@ -169,63 +169,65 @@ static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
 void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
 	 u32 dst_nextline, u32 dst_nextplane, u32 src_nextline, u32 bpp)
 {
-    int dst_idx;
-    u32 d[8], first, last, w;
-    const u8 *c;
-    u8 *p;
-
-    dst += dy*dst_nextline+(dx & ~31);
-    dst_idx = dx % 32;
-    first = ~0UL >> dst_idx;
-    last = ~(~0UL >> ((dst_idx+width) % 32));
-    while (height--) {
-	c = src;
-	p = dst;
-	w = width;
-	if (dst_idx+width <= 32) {
-	    /* Single destination word */
-	    first &= last;
-	    memset(d, 0, sizeof(d));
-	    memcpy((u8 *)d+dst_idx, c, width);
-	    c += width;
-	    c2p_8bpp(d);
-	    store_planar_masked(p, dst_nextplane, bpp, d, first);
-	    p += 4;
-	} else {
-	    /* Multiple destination words */
-	    w = width;
-	    /* Leading bits */
-	    if (dst_idx) {
-		w = 32 - dst_idx;
-		memset(d, 0, dst_idx);
-		memcpy((u8 *)d+dst_idx, c, w);
-		c += w;
-		c2p_8bpp(d);
-		store_planar_masked(p, dst_nextplane, bpp, d, first);
-		p += 4;
-		w = width-w;
-	    }
-	    /* Main chunk */
-	    while (w >= 32) {
-		memcpy(d, c, 32);
-		c += 32;
-		c2p_8bpp(d);
-		store_planar(p, dst_nextplane, bpp, d);
-		p += 4;
-		w -= 32;
-	    }
-	    /* Trailing bits */
-	    w %= 32;
-	    if (w > 0) {
-		memcpy(d, c, w);
-		memset((u8 *)d+w, 0, 32-w);
-		c2p_8bpp(d);
-		store_planar_masked(p, dst_nextplane, bpp, d, last);
-	    }
+	int dst_idx;
+	u32 d[8], first, last, w;
+	const u8 *c;
+	u8 *p;
+
+	dst += dy*dst_nextline+(dx & ~31);
+	dst_idx = dx % 32;
+	first = ~0UL >> dst_idx;
+	last = ~(~0UL >> ((dst_idx+width) % 32));
+	while (height--) {
+		c = src;
+		p = dst;
+		w = width;
+		if (dst_idx+width <= 32) {
+			/* Single destination word */
+			first &= last;
+			memset(d, 0, sizeof(d));
+			memcpy((u8 *)d+dst_idx, c, width);
+			c += width;
+			c2p_8bpp(d);
+			store_planar_masked(p, dst_nextplane, bpp, d, first);
+			p += 4;
+		} else {
+			/* Multiple destination words */
+			w = width;
+			/* Leading bits */
+			if (dst_idx) {
+				w = 32 - dst_idx;
+				memset(d, 0, dst_idx);
+				memcpy((u8 *)d+dst_idx, c, w);
+				c += w;
+				c2p_8bpp(d);
+				store_planar_masked(p, dst_nextplane, bpp, d,
+						    first);
+				p += 4;
+				w = width-w;
+			}
+			/* Main chunk */
+			while (w >= 32) {
+				memcpy(d, c, 32);
+				c += 32;
+				c2p_8bpp(d);
+				store_planar(p, dst_nextplane, bpp, d);
+				p += 4;
+				w -= 32;
+			}
+			/* Trailing bits */
+			w %= 32;
+			if (w > 0) {
+				memcpy(d, c, w);
+				memset((u8 *)d+w, 0, 32-w);
+				c2p_8bpp(d);
+				store_planar_masked(p, dst_nextplane, bpp, d,
+						    last);
+			}
+		}
+		src += src_nextline;
+		dst += dst_nextline;
 	}
-	src += src_nextline;
-	dst += dst_nextline;
-    }
 }
 EXPORT_SYMBOL_GPL(c2p);
 
-- 
1.5.6.5

