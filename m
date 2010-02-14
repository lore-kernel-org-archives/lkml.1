Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab0BNORm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:17:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab0BNORk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:17:40 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Feb 2010 14:17:35 +0000
Message-ID: <1266157055.10567.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/5] lib: Fix first line of kernel-doc for a few functions
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/list.h |    6 +++---
 lib/bitmap.c         |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 5d9c655..8392884 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -498,7 +498,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_continue
+ * list_for_each_entry_safe_continue - continue list iteration safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
@@ -514,7 +514,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_from
+ * list_for_each_entry_safe_from - iterate over list from current point safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
@@ -529,7 +529,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_reverse
+ * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 11bf497..61998c5 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -487,7 +487,7 @@ int __bitmap_parse(const char *buf, unsigned int buflen,
 EXPORT_SYMBOL(__bitmap_parse);
 
 /**
- * bitmap_parse_user()
+ * bitmap_parse_user - convert an ASCII hex string in a user buffer into a bitmap
  *
  * @ubuf: pointer to user buffer containing string.
  * @ulen: buffer size in bytes.  If string is smaller than this
@@ -619,7 +619,7 @@ int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
 EXPORT_SYMBOL(bitmap_parselist);
 
 /**
- * bitmap_pos_to_ord(buf, pos, bits)
+ * bitmap_pos_to_ord - find ordinal of set bit at given position in bitmap
  *	@buf: pointer to a bitmap
  *	@pos: a bit position in @buf (0 <= @pos < @bits)
  *	@bits: number of valid bit positions in @buf
@@ -655,7 +655,7 @@ static int bitmap_pos_to_ord(const unsigned long *buf, int pos, int bits)
 }
 
 /**
- * bitmap_ord_to_pos(buf, ord, bits)
+ * bitmap_ord_to_pos - find position of n-th set bit in bitmap
  *	@buf: pointer to bitmap
  *	@ord: ordinal bit position (n-th set bit, n >= 0)
  *	@bits: number of valid bit positions in @buf
-- 
1.6.6.2



