Return-Path: <linux-kernel-owner+w=401wt.eu-S1765878AbXH0ViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765878AbXH0ViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765157AbXH0V2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58852 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756523AbXH0V2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:50 -0400
Date: Mon, 27 Aug 2007 23:28:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] bitmap.h: remove dead artefacts
Message-ID: <20070827212848.GA26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bitmap_active() no longer exists and BITMAP_ACTIVE is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/raid/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

f2c10857c60e13e63c67c656713b50b18f2bc1e4 
diff --git a/include/linux/raid/bitmap.h b/include/linux/raid/bitmap.h
index 75e17a0..306a1d1 100644
--- a/include/linux/raid/bitmap.h
+++ b/include/linux/raid/bitmap.h
@@ -138,7 +138,6 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
 	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
 	BITMAP_HOSTENDIAN = 0x8000,
@@ -258,7 +257,6 @@ struct bitmap {
 int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
-int  bitmap_active(struct bitmap *bitmap);
 
 char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);

