Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYKEEs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYKEEs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 23:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYKEEsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 23:48:03 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:29212 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYKEEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 23:48:00 -0500
Date: Tue, 4 Nov 2008 20:46:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind@infradead.org>
Subject: [PATCH] ubifs: fix printk format warnings
Message-Id: <20081104204652.f8eb37a0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in ubifs.
Built cleanly on 7 arches.

fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/journal.c:1131: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/dir.c:163: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/tnc.c:2680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/tnc.c:2700: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/replay.c:1066: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'ino_t'
fs/ubifs/orphan.c:108: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:135: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:142: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:154: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:159: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:451: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:539: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:612: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:843: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:856: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1438: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1443: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1475: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1495: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:1591: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1671: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1674: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1699: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1788: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1821: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1833: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1924: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1932: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1938: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1945: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1953: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1967: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1973: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1988: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1991: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:2009: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ino_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Artem Bityutskiy <dedekind@infradead.org>
---
 fs/ubifs/debug.c    |   62 +++++++++++++++++++++++++++++++---------------------
 fs/ubifs/dir.c      |    2 -
 fs/ubifs/journal.c  |    6 +++--
 fs/ubifs/orphan.c   |   25 ++++++++++++--------
 fs/ubifs/recovery.c |   11 +++++----
 fs/ubifs/replay.c   |    2 -
 fs/ubifs/tnc.c      |    5 ++--
 7 files changed, 68 insertions(+), 45 deletions(-)

--- lin2628-rc3.orig/fs/ubifs/dir.c
+++ lin2628-rc3/fs/ubifs/dir.c
@@ -161,7 +161,7 @@ struct inode *ubifs_new_inode(struct ubi
 			return ERR_PTR(-EINVAL);
 		}
 		ubifs_warn("running out of inode numbers (current %lu, max %d)",
-			   c->highest_inum, INUM_WATERMARK);
+			   (unsigned long)c->highest_inum, INUM_WATERMARK);
 	}
 
 	inode->i_ino = ++c->highest_inum;
--- lin2628-rc3.orig/fs/ubifs/journal.c
+++ lin2628-rc3/fs/ubifs/journal.c
@@ -690,7 +690,8 @@ int ubifs_jnl_write_data(struct ubifs_in
 	int dlen = UBIFS_DATA_NODE_SZ + UBIFS_BLOCK_SIZE * WORST_COMPR_FACTOR;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
-	dbg_jnl("ino %lu, blk %u, len %d, key %s", key_inum(c, key),
+	dbg_jnl("ino %lu, blk %u, len %d, key %s",
+		(unsigned long)key_inum(c, key),
 		key_block(c, key), len, DBGKEY(key));
 	ubifs_assert(len <= UBIFS_BLOCK_SIZE);
 
@@ -1128,7 +1129,8 @@ int ubifs_jnl_truncate(struct ubifs_info
 	ino_t inum = inode->i_ino;
 	unsigned int blk;
 
-	dbg_jnl("ino %lu, size %lld -> %lld", inum, old_size, new_size);
+	dbg_jnl("ino %lu, size %lld -> %lld", (unsigned long)inum,
+		old_size, new_size);
 	ubifs_assert(!ui->data_len);
 	ubifs_assert(S_ISREG(inode->i_mode));
 	ubifs_assert(mutex_is_locked(&ui->ui_mutex));
--- lin2628-rc3.orig/fs/ubifs/replay.c
+++ lin2628-rc3/fs/ubifs/replay.c
@@ -1065,7 +1065,7 @@ int ubifs_replay_journal(struct ubifs_in
 	ubifs_assert(c->bud_bytes <= c->max_bud_bytes || c->need_recovery);
 	dbg_mnt("finished, log head LEB %d:%d, max_sqnum %llu, "
 		"highest_inum %lu", c->lhead_lnum, c->lhead_offs, c->max_sqnum,
-		c->highest_inum);
+		(unsigned long)c->highest_inum);
 out:
 	destroy_replay_tree(c);
 	destroy_bud_list(c);
--- lin2628-rc3.orig/fs/ubifs/tnc.c
+++ lin2628-rc3/fs/ubifs/tnc.c
@@ -2677,7 +2677,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 	struct ubifs_dent_node *xent, *pxent = NULL;
 	struct qstr nm = { .name = NULL };
 
-	dbg_tnc("ino %lu", inum);
+	dbg_tnc("ino %lu", (unsigned long)inum);
 
 	/*
 	 * Walk all extended attribute entries and remove them together with
@@ -2697,7 +2697,8 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 		}
 
 		xattr_inum = le64_to_cpu(xent->inum);
-		dbg_tnc("xent '%s', ino %lu", xent->name, xattr_inum);
+		dbg_tnc("xent '%s', ino %lu",
+			xent->name, (unsigned long)xattr_inum);
 
 		nm.name = xent->name;
 		nm.len = le16_to_cpu(xent->nlen);
--- lin2628-rc3.orig/fs/ubifs/orphan.c
+++ lin2628-rc3/fs/ubifs/orphan.c
@@ -105,7 +105,7 @@ int ubifs_add_orphan(struct ubifs_info *
 	list_add_tail(&orphan->list, &c->orph_list);
 	list_add_tail(&orphan->new_list, &c->orph_new);
 	spin_unlock(&c->orphan_lock);
-	dbg_gen("ino %lu", inum);
+	dbg_gen("ino %lu", (unsigned long)inum);
 	return 0;
 }
 
@@ -132,14 +132,16 @@ void ubifs_delete_orphan(struct ubifs_in
 		else {
 			if (o->dnext) {
 				spin_unlock(&c->orphan_lock);
-				dbg_gen("deleted twice ino %lu", inum);
+				dbg_gen("deleted twice ino %lu",
+					(unsigned long)inum);
 				return;
 			}
 			if (o->cnext) {
 				o->dnext = c->orph_dnext;
 				c->orph_dnext = o;
 				spin_unlock(&c->orphan_lock);
-				dbg_gen("delete later ino %lu", inum);
+				dbg_gen("delete later ino %lu",
+					(unsigned long)inum);
 				return;
 			}
 			rb_erase(p, &c->orph_tree);
@@ -151,12 +153,12 @@ void ubifs_delete_orphan(struct ubifs_in
 			}
 			spin_unlock(&c->orphan_lock);
 			kfree(o);
-			dbg_gen("inum %lu", inum);
+			dbg_gen("inum %lu", (unsigned long)inum);
 			return;
 		}
 	}
 	spin_unlock(&c->orphan_lock);
-	dbg_err("missing orphan ino %lu", inum);
+	dbg_err("missing orphan ino %lu", (unsigned long)inum);
 	dbg_dump_stack();
 }
 
@@ -448,7 +450,7 @@ static void erase_deleted(struct ubifs_i
 		rb_erase(&orphan->rb, &c->orph_tree);
 		list_del(&orphan->list);
 		c->tot_orphans -= 1;
-		dbg_gen("deleting orphan ino %lu", orphan->inum);
+		dbg_gen("deleting orphan ino %lu", (unsigned long)orphan->inum);
 		kfree(orphan);
 	}
 	c->orph_dnext = NULL;
@@ -537,7 +539,7 @@ static int insert_dead_orphan(struct ubi
 	orphan->dnext = c->orph_dnext;
 	c->orph_dnext = orphan;
 	dbg_mnt("ino %lu, new %d, tot %d",
-		inum, c->new_orphans, c->tot_orphans);
+		(unsigned long)inum, c->new_orphans, c->tot_orphans);
 	return 0;
 }
 
@@ -609,7 +611,8 @@ static int do_kill_orphans(struct ubifs_
 		n = (le32_to_cpu(orph->ch.len) - UBIFS_ORPH_NODE_SZ) >> 3;
 		for (i = 0; i < n; i++) {
 			inum = le64_to_cpu(orph->inos[i]);
-			dbg_rcvry("deleting orphaned inode %lu", inum);
+			dbg_rcvry("deleting orphaned inode %lu",
+				(unsigned long)inum);
 			err = ubifs_tnc_remove_ino(c, inum);
 			if (err)
 				return err;
@@ -840,7 +843,8 @@ static int dbg_orphan_check(struct ubifs
 	if (inum != ci->last_ino) {
 		/* Lowest node type is the inode node, so it comes first */
 		if (key_type(c, &zbr->key) != UBIFS_INO_KEY)
-			ubifs_err("found orphan node ino %lu, type %d", inum,
+			ubifs_err("found orphan node ino %lu, type %d",
+				  (unsigned long)inum,
 				  key_type(c, &zbr->key));
 		ci->last_ino = inum;
 		ci->tot_inos += 1;
@@ -853,7 +857,8 @@ static int dbg_orphan_check(struct ubifs
 			/* Must be recorded as an orphan */
 			if (!dbg_find_check_orphan(&ci->root, inum) &&
 			    !dbg_find_orphan(c, inum)) {
-				ubifs_err("missing orphan, ino %lu", inum);
+				ubifs_err("missing orphan, ino %lu",
+					(unsigned long)inum);
 				ci->missing += 1;
 			}
 	}
--- lin2628-rc3.orig/fs/ubifs/recovery.c
+++ lin2628-rc3/fs/ubifs/recovery.c
@@ -1435,13 +1435,14 @@ static int fix_size_in_place(struct ubif
 	err = ubi_leb_change(c->ubi, lnum, c->sbuf, len, UBI_UNKNOWN);
 	if (err)
 		goto out;
-	dbg_rcvry("inode %lu at %d:%d size %lld -> %lld ", e->inum, lnum, offs,
+	dbg_rcvry("inode %lu at %d:%d size %lld -> %lld ",
+		  (unsigned long)e->inum, lnum, offs,
 		  i_size, e->d_size);
 	return 0;
 
 out:
 	ubifs_warn("inode %lu failed to fix size %lld -> %lld error %d",
-		   e->inum, e->i_size, e->d_size, err);
+		   (unsigned long)e->inum, e->i_size, e->d_size, err);
 	return err;
 }
 
@@ -1472,7 +1473,8 @@ int ubifs_recover_size(struct ubifs_info
 				return err;
 			if (err == -ENOENT) {
 				/* Remove data nodes that have no inode */
-				dbg_rcvry("removing ino %lu", e->inum);
+				dbg_rcvry("removing ino %lu",
+					(unsigned long)e->inum);
 				err = ubifs_tnc_remove_ino(c, e->inum);
 				if (err)
 					return err;
@@ -1493,7 +1495,8 @@ int ubifs_recover_size(struct ubifs_info
 					return PTR_ERR(inode);
 				if (inode->i_size < e->d_size) {
 					dbg_rcvry("ino %lu size %lld -> %lld",
-						  e->inum, e->d_size,
+						  (unsigned long)e->inum,
+						  e->d_size,
 						  inode->i_size);
 					inode->i_size = e->d_size;
 					ubifs_inode(inode)->ui_size = e->d_size;
--- lin2628-rc3.orig/fs/ubifs/debug.c
+++ lin2628-rc3/fs/ubifs/debug.c
@@ -101,21 +101,24 @@ static void sprintf_key(const struct ubi
 	if (c->key_fmt == UBIFS_SIMPLE_KEY_FMT) {
 		switch (type) {
 		case UBIFS_INO_KEY:
-			sprintf(p, "(%lu, %s)", key_inum(c, key),
+			sprintf(p, "(%lu, %s)", (unsigned long)key_inum(c, key),
 			       get_key_type(type));
 			break;
 		case UBIFS_DENT_KEY:
 		case UBIFS_XENT_KEY:
-			sprintf(p, "(%lu, %s, %#08x)", key_inum(c, key),
+			sprintf(p, "(%lu, %s, %#08x)",
+				(unsigned long)key_inum(c, key),
 				get_key_type(type), key_hash(c, key));
 			break;
 		case UBIFS_DATA_KEY:
-			sprintf(p, "(%lu, %s, %u)", key_inum(c, key),
+			sprintf(p, "(%lu, %s, %u)",
+				(unsigned long)key_inum(c, key),
 				get_key_type(type), key_block(c, key));
 			break;
 		case UBIFS_TRUN_KEY:
 			sprintf(p, "(%lu, %s)",
-				key_inum(c, key), get_key_type(type));
+				(unsigned long)key_inum(c, key),
+				get_key_type(type));
 			break;
 		default:
 			sprintf(p, "(bad key type: %#08x, %#08x)",
@@ -1589,7 +1592,7 @@ static struct fsck_inode *add_inode(stru
 
 	if (inum > c->highest_inum) {
 		ubifs_err("too high inode number, max. is %lu",
-			  c->highest_inum);
+			  (unsigned long)c->highest_inum);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1668,16 +1671,18 @@ static struct fsck_inode *read_add_inode
 	ino_key_init(c, &key, inum);
 	err = ubifs_lookup_level0(c, &key, &znode, &n);
 	if (!err) {
-		ubifs_err("inode %lu not found in index", inum);
+		ubifs_err("inode %lu not found in index", (unsigned long)inum);
 		return ERR_PTR(-ENOENT);
 	} else if (err < 0) {
-		ubifs_err("error %d while looking up inode %lu", err, inum);
+		ubifs_err("error %d while looking up inode %lu",
+			err, (unsigned long)inum);
 		return ERR_PTR(err);
 	}
 
 	zbr = &znode->zbranch[n];
 	if (zbr->len < UBIFS_INO_NODE_SZ) {
-		ubifs_err("bad node %lu node length %d", inum, zbr->len);
+		ubifs_err("bad node %lu node length %d",
+			(unsigned long)inum, zbr->len);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1697,7 +1702,7 @@ static struct fsck_inode *read_add_inode
 	kfree(ino);
 	if (IS_ERR(fscki)) {
 		ubifs_err("error %ld while adding inode %lu node",
-			  PTR_ERR(fscki), inum);
+			  PTR_ERR(fscki), (unsigned long)inum);
 		return fscki;
 	}
 
@@ -1786,7 +1791,8 @@ static int check_leaf(struct ubifs_info 
 		if (IS_ERR(fscki)) {
 			err = PTR_ERR(fscki);
 			ubifs_err("error %d while processing data node and "
-				  "trying to find inode node %lu", err, inum);
+				  "trying to find inode node %lu",
+				  err, (unsigned long)inum);
 			goto out_dump;
 		}
 
@@ -1819,7 +1825,8 @@ static int check_leaf(struct ubifs_info 
 		if (IS_ERR(fscki)) {
 			err = PTR_ERR(fscki);
 			ubifs_err("error %d while processing entry node and "
-				  "trying to find inode node %lu", err, inum);
+				  "trying to find inode node %lu",
+				  err, (unsigned long)inum);
 			goto out_dump;
 		}
 
@@ -1832,7 +1839,7 @@ static int check_leaf(struct ubifs_info 
 			err = PTR_ERR(fscki);
 			ubifs_err("error %d while processing entry node and "
 				  "trying to find parent inode node %lu",
-				  err, inum);
+				  err, (unsigned long)inum);
 			goto out_dump;
 		}
 
@@ -1923,7 +1930,8 @@ static int check_inodes(struct ubifs_inf
 			    fscki->references != 1) {
 				ubifs_err("directory inode %lu has %d "
 					  "direntries which refer it, but "
-					  "should be 1", fscki->inum,
+					  "should be 1",
+					  (unsigned long)fscki->inum,
 					  fscki->references);
 				goto out_dump;
 			}
@@ -1931,27 +1939,29 @@ static int check_inodes(struct ubifs_inf
 			    fscki->references != 0) {
 				ubifs_err("root inode %lu has non-zero (%d) "
 					  "direntries which refer it",
-					  fscki->inum, fscki->references);
+					  (unsigned long)fscki->inum,
+					  fscki->references);
 				goto out_dump;
 			}
 			if (fscki->calc_sz != fscki->size) {
 				ubifs_err("directory inode %lu size is %lld, "
 					  "but calculated size is %lld",
-					  fscki->inum, fscki->size,
-					  fscki->calc_sz);
+					  (unsigned long)fscki->inum,
+					  fscki->size, fscki->calc_sz);
 				goto out_dump;
 			}
 			if (fscki->calc_cnt != fscki->nlink) {
 				ubifs_err("directory inode %lu nlink is %d, "
 					  "but calculated nlink is %d",
-					  fscki->inum, fscki->nlink,
-					  fscki->calc_cnt);
+					  (unsigned long)fscki->inum,
+					  fscki->nlink, fscki->calc_cnt);
 				goto out_dump;
 			}
 		} else {
 			if (fscki->references != fscki->nlink) {
 				ubifs_err("inode %lu nlink is %d, but "
-					  "calculated nlink is %d", fscki->inum,
+					  "calculated nlink is %d",
+					  (unsigned long)fscki->inum,
 					  fscki->nlink, fscki->references);
 				goto out_dump;
 			}
@@ -1959,20 +1969,21 @@ static int check_inodes(struct ubifs_inf
 		if (fscki->xattr_sz != fscki->calc_xsz) {
 			ubifs_err("inode %lu has xattr size %u, but "
 				  "calculated size is %lld",
-				  fscki->inum, fscki->xattr_sz,
+				  (unsigned long)fscki->inum, fscki->xattr_sz,
 				  fscki->calc_xsz);
 			goto out_dump;
 		}
 		if (fscki->xattr_cnt != fscki->calc_xcnt) {
 			ubifs_err("inode %lu has %u xattrs, but "
-				  "calculated count is %lld", fscki->inum,
+				  "calculated count is %lld",
+				  (unsigned long)fscki->inum,
 				  fscki->xattr_cnt, fscki->calc_xcnt);
 			goto out_dump;
 		}
 		if (fscki->xattr_nms != fscki->calc_xnms) {
 			ubifs_err("inode %lu has xattr names' size %u, but "
 				  "calculated names' size is %lld",
-				  fscki->inum, fscki->xattr_nms,
+				  (unsigned long)fscki->inum, fscki->xattr_nms,
 				  fscki->calc_xnms);
 			goto out_dump;
 		}
@@ -1985,11 +1996,12 @@ out_dump:
 	ino_key_init(c, &key, fscki->inum);
 	err = ubifs_lookup_level0(c, &key, &znode, &n);
 	if (!err) {
-		ubifs_err("inode %lu not found in index", fscki->inum);
+		ubifs_err("inode %lu not found in index",
+			  (unsigned long)fscki->inum);
 		return -ENOENT;
 	} else if (err < 0) {
 		ubifs_err("error %d while looking up inode %lu",
-			  err, fscki->inum);
+			  err, (unsigned long)fscki->inum);
 		return err;
 	}
 
@@ -2007,7 +2019,7 @@ out_dump:
 	}
 
 	ubifs_msg("dump of the inode %lu sitting in LEB %d:%d",
-		  fscki->inum, zbr->lnum, zbr->offs);
+		  (unsigned long)fscki->inum, zbr->lnum, zbr->offs);
 	dbg_dump_node(c, ino);
 	kfree(ino);
 	return -EINVAL;
