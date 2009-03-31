Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZCaJDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZCaJDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZCaJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:02:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:43800 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZCaJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BsiWyrFgpe43aThF7WZjSPLqZMq/ba7nX+MzuH1Y0blp+R0Bz7sqzFk7mXlXv+kN1z
         gzDcmutxmebawlqgotllQJSLD2/dD9Qd1X1iw6EQ3xVt0e76Hi0JvUvNO9FZPcE+bszJ
         NFPmV/anYkJ9n+gJ+ARTjLqDw9D6DQfOG9H5g=
MIME-Version: 1.0
In-Reply-To: <20090331060423.GR28946@ZenIV.linux.org.uk>
References: <ea11fea30903222039r4bec470crfd9825e37a926d56@mail.gmail.com> 
	<20090330163619.d08ba85e.akpm@linux-foundation.org> <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com> 
	<20090331060423.GR28946@ZenIV.linux.org.uk>
Date: Tue, 31 Mar 2009 14:32:37 +0530
Message-ID: <ea11fea30903310202i738c1f05y754ea0a1a56574eb@mail.gmail.com>
Subject: Re: [PATCH] : Code cleanup for fs/inode.c as per checkpatch.pl
From: Manish Katiyar <mkatiyar@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016363ba868d4a41d04666676cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363ba868d4a41d04666676cf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2009 at 11:34 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Mar 31, 2009 at 08:13:56AM +0530, Manish Katiyar wrote:
>> On Tue, Mar 31, 2009 at 5:06 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Mon, 23 Mar 2009 09:09:26 +0530
>> > Manish Katiyar <mkatiyar@gmail.com> wrote:
>> >
>> >> Code cleanup for fs/inode.c as per checkpatch.pl
>> >> Before:
>> >> total: 24 errors, 25 warnings, 1546 lines checked
>> >> After:
>> >> total: 0 errors, 0 warnings, 1539 lines checked
>> >
>> > Probably OK, but again, please cc linux-kernel and/or linx-fsdevel.
>>
>> Hi Andrew,
>>
>> [ cced lkml ]
>
> That you have. =A0Now, how about the patch itself? ;-)

Sorry, didn't realise that this didn't send the original message :-(.
Below is the complete patch. I have also attached it in case it gets
word wrapped even after using plugin with gmail.


Code cleanup for fs/inode.c as per checkpatch.pl
Before:
total: 24 errors, 25 warnings, 1546 lines checked
After:
total: 0 errors, 0 warnings, 1539 lines checked


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/inode.c |   78 ++++++++++++++++++++++++--------------------------------=
---
 1 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index f75e9a4..e0dad15 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -98,7 +98,7 @@ static DEFINE_MUTEX(iprune_mutex);
  */
 struct inodes_stat_t inodes_stat;

-static struct kmem_cache * inode_cachep __read_mostly;
+static struct kmem_cache *inode_cachep __read_mostly;

 static void wake_up_inode(struct inode *inode)
 {
@@ -123,7 +123,7 @@ struct inode *inode_init_always(struct super_block
*sb, struct inode *inode)
 	static struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;

-	struct address_space * const mapping =3D &inode->i_data;
+	struct address_space *const mapping =3D &inode->i_data;

 	inode->i_sb =3D sb;
 	inode->i_blkbits =3D sb->s_blocksize_bits;
@@ -206,7 +206,7 @@ static struct inode *alloc_inode(struct super_block *sb=
)
 	return NULL;
 }

-void destroy_inode(struct inode *inode)
+void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
@@ -242,12 +242,11 @@ void inode_init_once(struct inode *inode)
 	mutex_init(&inode->inotify_mutex);
 #endif
 }
-
 EXPORT_SYMBOL(inode_init_once);

 static void init_once(void *foo)
 {
-	struct inode * inode =3D (struct inode *) foo;
+	struct inode *inode =3D (struct inode *) foo;

 	inode_init_once(inode);
 }
@@ -255,7 +254,7 @@ static void init_once(void *foo)
 /*
  * inode_lock must be held
  */
-void __iget(struct inode * inode)
+void __iget(struct inode *inode)
 {
 	if (atomic_read(&inode->i_count)) {
 		atomic_inc(&inode->i_count);
@@ -279,7 +278,7 @@ void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	invalidate_inode_buffers(inode);
-
+
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -293,7 +292,6 @@ void clear_inode(struct inode *inode)
 		cd_forget(inode);
 	inode->i_state =3D I_CLEAR;
 }
-
 EXPORT_SYMBOL(clear_inode);

 /*
@@ -341,8 +339,8 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)

 	next =3D head->next;
 	for (;;) {
-		struct list_head * tmp =3D next;
-		struct inode * inode;
+		struct list_head *tmp =3D next;
+		struct inode *inode;

 		/*
 		 * We can reschedule here without worrying about the list's
@@ -378,7 +376,7 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)
  *	fails because there are busy inodes then a non zero value is returned.
  *	If the discard is successful all the inodes have been discarded.
  */
-int invalidate_inodes(struct super_block * sb)
+int invalidate_inodes(struct super_block *sb)
 {
 	int busy;
 	LIST_HEAD(throw_away);
@@ -394,7 +392,6 @@ int invalidate_inodes(struct super_block * sb)

 	return busy;
 }
-
 EXPORT_SYMBOL(invalidate_inodes);

 static int can_unuse(struct inode *inode)
@@ -490,7 +487,7 @@ static int shrink_icache_memory(int nr, gfp_t gfp_mask)
 		 * Nasty deadlock avoidance.  We may hold various FS locks,
 		 * and we don't want to recurse into the FS that called us
 		 * in clear_inode() and friends..
-	 	 */
+		 */
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 		prune_icache(nr);
@@ -510,10 +507,11 @@ static void __wait_on_freeing_inode(struct inode *ino=
de);
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
  */
-static struct inode * find_inode(struct super_block * sb, struct
hlist_head *head, int (*test)(struct inode *, void *), void *data)
+static struct inode *find_inode(struct super_block *sb, struct
hlist_head *head,
+				int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -534,10 +532,11 @@ repeat:
  * find_inode_fast is the fast path version of find_inode, see the comment=
 at
  * iget_locked for details.
  */
-static struct inode * find_inode_fast(struct super_block * sb, struct
hlist_head *head, unsigned long ino)
+static struct inode *find_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -617,10 +616,10 @@ struct inode *new_inode(struct super_block *sb)
 	 * here to attempt to avoid that.
 	 */
 	static unsigned int last_ino;
-	struct inode * inode;
+	struct inode *inode;

 	spin_lock_prefetch(&inode_lock);
-=09
+
 	inode =3D alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
@@ -631,7 +630,6 @@ struct inode *new_inode(struct super_block *sb)
 	}
 	return inode;
 }
-
 EXPORT_SYMBOL(new_inode);

 void unlock_new_inode(struct inode *inode)
@@ -659,7 +657,6 @@ void unlock_new_inode(struct inode *inode)
 	inode->i_state &=3D ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
 }
-
 EXPORT_SYMBOL(unlock_new_inode);

 /*
@@ -668,13 +665,16 @@ EXPORT_SYMBOL(unlock_new_inode);
  * We no longer cache the sb_flags in i_flags - see fs.h
  *	-- rmk@arm.uk.linux.org
  */
-static struct inode * get_new_inode(struct super_block *sb, struct
hlist_head *head, int (*test)(struct inode *, void *), int
(*set)(struct inode *, void *), void *data)
+static struct inode *get_new_inode(struct super_block *sb,
+				struct hlist_head *head,
+				int (*test)(struct inode *, void *),
+				int (*set)(struct inode *, void *), void *data)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -716,13 +716,14 @@ set_failed:
  * get_new_inode_fast is the fast path version of get_new_inode, see the
  * comment at iget_locked for details.
  */
-static struct inode * get_new_inode_fast(struct super_block *sb,
struct hlist_head *head, unsigned long ino)
+static struct inode *get_new_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -808,7 +809,6 @@ struct inode *igrab(struct inode *inode)
 	spin_unlock(&inode_lock);
 	return inode;
 }
-
 EXPORT_SYMBOL(igrab);

 /**
@@ -909,7 +909,6 @@ struct inode *ilookup5_nowait(struct super_block
*sb, unsigned long hashval,

 	return ifind(sb, head, test, data, 0);
 }
-
 EXPORT_SYMBOL(ilookup5_nowait);

 /**
@@ -938,7 +937,6 @@ struct inode *ilookup5(struct super_block *sb,
unsigned long hashval,

 	return ifind(sb, head, test, data, 1);
 }
-
 EXPORT_SYMBOL(ilookup5);

 /**
@@ -961,7 +959,6 @@ struct inode *ilookup(struct super_block *sb,
unsigned long ino)

 	return ifind_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(ilookup);

 /**
@@ -1000,7 +997,6 @@ struct inode *iget5_locked(struct super_block
*sb, unsigned long hashval,
 	 */
 	return get_new_inode(sb, head, test, set, data);
 }
-
 EXPORT_SYMBOL(iget5_locked);

 /**
@@ -1032,7 +1028,6 @@ struct inode *iget_locked(struct super_block
*sb, unsigned long ino)
 	 */
 	return get_new_inode_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(iget_locked);

 int insert_inode_locked(struct inode *inode)
@@ -1061,7 +1056,6 @@ int insert_inode_locked(struct inode *inode)
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked);

 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
@@ -1091,7 +1085,6 @@ int insert_inode_locked4(struct inode *inode,
unsigned long hashval,
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked4);

 /**
@@ -1109,7 +1102,6 @@ void __insert_inode_hash(struct inode *inode,
unsigned long hashval)
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(__insert_inode_hash);

 /**
@@ -1124,7 +1116,6 @@ void remove_inode_hash(struct inode *inode)
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(remove_inode_hash);

 /*
@@ -1171,7 +1162,6 @@ void generic_delete_inode(struct inode *inode)
 	BUG_ON(inode->i_state !=3D I_CLEAR);
 	destroy_inode(inode);
 }
-
 EXPORT_SYMBOL(generic_delete_inode);

 static void generic_forget_inode(struct inode *inode)
@@ -1218,12 +1208,11 @@ void generic_drop_inode(struct inode *inode)
 	else
 		generic_forget_inode(inode);
 }
-
 EXPORT_SYMBOL_GPL(generic_drop_inode);

 /*
  * Called when we're dropping the last reference
- * to an inode.
+ * to an inode.
  *
  * Call the FS "drop()" function, defaulting to
  * the legacy UNIX filesystem behaviour..
@@ -1243,7 +1232,7 @@ static inline void iput_final(struct inode *inode)
 }

 /**
- *	iput	- put an inode
+ *	iput	- put an inode
  *	@inode: inode to put
  *
  *	Puts an inode, dropping its usage count. If the inode use count hits
@@ -1260,7 +1249,6 @@ void iput(struct inode *inode)
 			iput_final(inode);
 	}
 }
-
 EXPORT_SYMBOL(iput);

 /**
@@ -1271,10 +1259,10 @@ EXPORT_SYMBOL(iput);
  *	Returns the block number on the device holding the inode that
  *	is the disk block number for the block of the file requested.
  *	That is, asked for block 4 of inode 1 the function will return the
- *	disk block relative to the disk start that holds that block of the
+ *	disk block relative to the disk start that holds that block of the
  *	file.
  */
-sector_t bmap(struct inode * inode, sector_t block)
+sector_t bmap(struct inode *inode, sector_t block)
 {
 	sector_t res =3D 0;
 	if (inode->i_mapping->a_ops->bmap)
@@ -1377,7 +1365,6 @@ void file_update_time(struct file *file)
 		mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
-
 EXPORT_SYMBOL(file_update_time);

 int inode_needs_sync(struct inode *inode)
@@ -1388,7 +1375,6 @@ int inode_needs_sync(struct inode *inode)
 		return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL(inode_needs_sync);

 int inode_wait(void *word)
--=20
1.5.4.3



Thanks -
Manish

>

--0016363ba868d4a41d04666676cf
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0002-Patch-cleanup-for-fs-inode.c-as-per-checkpatch.pl.patch"
Content-Disposition: attachment; 
	filename="0002-Patch-cleanup-for-fs-inode.c-as-per-checkpatch.pl.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fsyda3u60

RnJvbSAzZWMxOGUyOGQ0MzlkNTBjMjc0NzExZGFiYjBlZmU0ZTA5NGRhNTFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBNb24sIDIzIE1hciAyMDA5IDA4OjEwOjE4ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gUGF0
Y2ggY2xlYW51cCBmb3IgZnMvaW5vZGUuYyBhcyBwZXIgY2hlY2twYXRjaC5wbAoKClNpZ25lZC1v
ZmYtYnk6IE1hbmlzaCBLYXRpeWFyIDxta2F0aXlhckBnbWFpbC5jb20+Ci0tLQogZnMvaW5vZGUu
YyB8ICAgNzggKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgNDYgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvaW5vZGUuYyBiL2ZzL2lub2RlLmMKaW5kZXggZjc1ZTlh
NC4uZTBkYWQxNSAxMDA2NDQKLS0tIGEvZnMvaW5vZGUuYworKysgYi9mcy9pbm9kZS5jCkBAIC05
OCw3ICs5OCw3IEBAIHN0YXRpYyBERUZJTkVfTVVURVgoaXBydW5lX211dGV4KTsKICAqLwogc3Ry
dWN0IGlub2Rlc19zdGF0X3QgaW5vZGVzX3N0YXQ7CiAKLXN0YXRpYyBzdHJ1Y3Qga21lbV9jYWNo
ZSAqIGlub2RlX2NhY2hlcCBfX3JlYWRfbW9zdGx5Oworc3RhdGljIHN0cnVjdCBrbWVtX2NhY2hl
ICppbm9kZV9jYWNoZXAgX19yZWFkX21vc3RseTsKIAogc3RhdGljIHZvaWQgd2FrZV91cF9pbm9k
ZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogewpAQCAtMTIzLDcgKzEyMyw3IEBAIHN0cnVjdCBpbm9k
ZSAqaW5vZGVfaW5pdF9hbHdheXMoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0IGlub2Rl
ICppbm9kZSkKIAlzdGF0aWMgc3RydWN0IGlub2RlX29wZXJhdGlvbnMgZW1wdHlfaW9wczsKIAlz
dGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBlbXB0eV9mb3BzOwogCi0Jc3RydWN0
IGFkZHJlc3Nfc3BhY2UgKiBjb25zdCBtYXBwaW5nID0gJmlub2RlLT5pX2RhdGE7CisJc3RydWN0
IGFkZHJlc3Nfc3BhY2UgKmNvbnN0IG1hcHBpbmcgPSAmaW5vZGUtPmlfZGF0YTsKIAogCWlub2Rl
LT5pX3NiID0gc2I7CiAJaW5vZGUtPmlfYmxrYml0cyA9IHNiLT5zX2Jsb2Nrc2l6ZV9iaXRzOwpA
QCAtMjA2LDcgKzIwNiw3IEBAIHN0YXRpYyBzdHJ1Y3QgaW5vZGUgKmFsbG9jX2lub2RlKHN0cnVj
dCBzdXBlcl9ibG9jayAqc2IpCiAJcmV0dXJuIE5VTEw7CiB9CiAKLXZvaWQgZGVzdHJveV9pbm9k
ZShzdHJ1Y3QgaW5vZGUgKmlub2RlKSAKK3ZvaWQgZGVzdHJveV9pbm9kZShzdHJ1Y3QgaW5vZGUg
Kmlub2RlKQogewogCUJVR19PTihpbm9kZV9oYXNfYnVmZmVycyhpbm9kZSkpOwogCXNlY3VyaXR5
X2lub2RlX2ZyZWUoaW5vZGUpOwpAQCAtMjQyLDEyICsyNDIsMTEgQEAgdm9pZCBpbm9kZV9pbml0
X29uY2Uoc3RydWN0IGlub2RlICppbm9kZSkKIAltdXRleF9pbml0KCZpbm9kZS0+aW5vdGlmeV9t
dXRleCk7CiAjZW5kaWYKIH0KLQogRVhQT1JUX1NZTUJPTChpbm9kZV9pbml0X29uY2UpOwogCiBz
dGF0aWMgdm9pZCBpbml0X29uY2Uodm9pZCAqZm9vKQogewotCXN0cnVjdCBpbm9kZSAqIGlub2Rl
ID0gKHN0cnVjdCBpbm9kZSAqKSBmb287CisJc3RydWN0IGlub2RlICppbm9kZSA9IChzdHJ1Y3Qg
aW5vZGUgKikgZm9vOwogCiAJaW5vZGVfaW5pdF9vbmNlKGlub2RlKTsKIH0KQEAgLTI1NSw3ICsy
NTQsNyBAQCBzdGF0aWMgdm9pZCBpbml0X29uY2Uodm9pZCAqZm9vKQogLyoKICAqIGlub2RlX2xv
Y2sgbXVzdCBiZSBoZWxkCiAgKi8KLXZvaWQgX19pZ2V0KHN0cnVjdCBpbm9kZSAqIGlub2RlKQor
dm9pZCBfX2lnZXQoc3RydWN0IGlub2RlICppbm9kZSkKIHsKIAlpZiAoYXRvbWljX3JlYWQoJmlu
b2RlLT5pX2NvdW50KSkgewogCQlhdG9taWNfaW5jKCZpbm9kZS0+aV9jb3VudCk7CkBAIC0yNzks
NyArMjc4LDcgQEAgdm9pZCBjbGVhcl9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogewogCW1p
Z2h0X3NsZWVwKCk7CiAJaW52YWxpZGF0ZV9pbm9kZV9idWZmZXJzKGlub2RlKTsKLSAgICAgICAK
KwogCUJVR19PTihpbm9kZS0+aV9kYXRhLm5ycGFnZXMpOwogCUJVR19PTighKGlub2RlLT5pX3N0
YXRlICYgSV9GUkVFSU5HKSk7CiAJQlVHX09OKGlub2RlLT5pX3N0YXRlICYgSV9DTEVBUik7CkBA
IC0yOTMsNyArMjkyLDYgQEAgdm9pZCBjbGVhcl9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQog
CQljZF9mb3JnZXQoaW5vZGUpOwogCWlub2RlLT5pX3N0YXRlID0gSV9DTEVBUjsKIH0KLQogRVhQ
T1JUX1NZTUJPTChjbGVhcl9pbm9kZSk7CiAKIC8qCkBAIC0zNDEsOCArMzM5LDggQEAgc3RhdGlj
IGludCBpbnZhbGlkYXRlX2xpc3Qoc3RydWN0IGxpc3RfaGVhZCAqaGVhZCwgc3RydWN0IGxpc3Rf
aGVhZCAqZGlzcG9zZSkKIAogCW5leHQgPSBoZWFkLT5uZXh0OwogCWZvciAoOzspIHsKLQkJc3Ry
dWN0IGxpc3RfaGVhZCAqIHRtcCA9IG5leHQ7Ci0JCXN0cnVjdCBpbm9kZSAqIGlub2RlOworCQlz
dHJ1Y3QgbGlzdF9oZWFkICp0bXAgPSBuZXh0OworCQlzdHJ1Y3QgaW5vZGUgKmlub2RlOwogCiAJ
CS8qCiAJCSAqIFdlIGNhbiByZXNjaGVkdWxlIGhlcmUgd2l0aG91dCB3b3JyeWluZyBhYm91dCB0
aGUgbGlzdCdzCkBAIC0zNzgsNyArMzc2LDcgQEAgc3RhdGljIGludCBpbnZhbGlkYXRlX2xpc3Qo
c3RydWN0IGxpc3RfaGVhZCAqaGVhZCwgc3RydWN0IGxpc3RfaGVhZCAqZGlzcG9zZSkKICAqCWZh
aWxzIGJlY2F1c2UgdGhlcmUgYXJlIGJ1c3kgaW5vZGVzIHRoZW4gYSBub24gemVybyB2YWx1ZSBp
cyByZXR1cm5lZC4KICAqCUlmIHRoZSBkaXNjYXJkIGlzIHN1Y2Nlc3NmdWwgYWxsIHRoZSBpbm9k
ZXMgaGF2ZSBiZWVuIGRpc2NhcmRlZC4KICAqLwotaW50IGludmFsaWRhdGVfaW5vZGVzKHN0cnVj
dCBzdXBlcl9ibG9jayAqIHNiKQoraW50IGludmFsaWRhdGVfaW5vZGVzKHN0cnVjdCBzdXBlcl9i
bG9jayAqc2IpCiB7CiAJaW50IGJ1c3k7CiAJTElTVF9IRUFEKHRocm93X2F3YXkpOwpAQCAtMzk0
LDcgKzM5Miw2IEBAIGludCBpbnZhbGlkYXRlX2lub2RlcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKiBz
YikKIAogCXJldHVybiBidXN5OwogfQotCiBFWFBPUlRfU1lNQk9MKGludmFsaWRhdGVfaW5vZGVz
KTsKIAogc3RhdGljIGludCBjYW5fdW51c2Uoc3RydWN0IGlub2RlICppbm9kZSkKQEAgLTQ5MCw3
ICs0ODcsNyBAQCBzdGF0aWMgaW50IHNocmlua19pY2FjaGVfbWVtb3J5KGludCBuciwgZ2ZwX3Qg
Z2ZwX21hc2spCiAJCSAqIE5hc3R5IGRlYWRsb2NrIGF2b2lkYW5jZS4gIFdlIG1heSBob2xkIHZh
cmlvdXMgRlMgbG9ja3MsCiAJCSAqIGFuZCB3ZSBkb24ndCB3YW50IHRvIHJlY3Vyc2UgaW50byB0
aGUgRlMgdGhhdCBjYWxsZWQgdXMKIAkJICogaW4gY2xlYXJfaW5vZGUoKSBhbmQgZnJpZW5kcy4u
Ci0JIAkgKi8KKwkJICovCiAJCWlmICghKGdmcF9tYXNrICYgX19HRlBfRlMpKQogCQkJcmV0dXJu
IC0xOwogCQlwcnVuZV9pY2FjaGUobnIpOwpAQCAtNTEwLDEwICs1MDcsMTEgQEAgc3RhdGljIHZv
aWQgX193YWl0X29uX2ZyZWVpbmdfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSk7CiAgKiBieSBo
YW5kIGFmdGVyIGNhbGxpbmcgZmluZF9pbm9kZSBub3chIFRoaXMgc2ltcGxpZmllcyBpdW5pcXVl
IGFuZCB3b24ndAogICogYWRkIGFueSBhZGRpdGlvbmFsIGJyYW5jaCBpbiB0aGUgY29tbW9uIGNv
ZGUuCiAgKi8KLXN0YXRpYyBzdHJ1Y3QgaW5vZGUgKiBmaW5kX2lub2RlKHN0cnVjdCBzdXBlcl9i
bG9jayAqIHNiLCBzdHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCwgaW50ICgqdGVzdCkoc3RydWN0IGlu
b2RlICosIHZvaWQgKiksIHZvaWQgKmRhdGEpCitzdGF0aWMgc3RydWN0IGlub2RlICpmaW5kX2lu
b2RlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBobGlzdF9oZWFkICpoZWFkLAorCQkJ
CWludCAoKnRlc3QpKHN0cnVjdCBpbm9kZSAqLCB2b2lkICopLCB2b2lkICpkYXRhKQogewogCXN0
cnVjdCBobGlzdF9ub2RlICpub2RlOwotCXN0cnVjdCBpbm9kZSAqIGlub2RlID0gTlVMTDsKKwlz
dHJ1Y3QgaW5vZGUgKmlub2RlID0gTlVMTDsKIAogcmVwZWF0OgogCWhsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGlub2RlLCBub2RlLCBoZWFkLCBpX2hhc2gpIHsKQEAgLTUzNCwxMCArNTMyLDExIEBAIHJl
cGVhdDoKICAqIGZpbmRfaW5vZGVfZmFzdCBpcyB0aGUgZmFzdCBwYXRoIHZlcnNpb24gb2YgZmlu
ZF9pbm9kZSwgc2VlIHRoZSBjb21tZW50IGF0CiAgKiBpZ2V0X2xvY2tlZCBmb3IgZGV0YWlscy4K
ICAqLwotc3RhdGljIHN0cnVjdCBpbm9kZSAqIGZpbmRfaW5vZGVfZmFzdChzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKiBzYiwgc3RydWN0IGhsaXN0X2hlYWQgKmhlYWQsIHVuc2lnbmVkIGxvbmcgaW5vKQor
c3RhdGljIHN0cnVjdCBpbm9kZSAqZmluZF9pbm9kZV9mYXN0KHN0cnVjdCBzdXBlcl9ibG9jayAq
c2IsCisJCQkJc3RydWN0IGhsaXN0X2hlYWQgKmhlYWQsIHVuc2lnbmVkIGxvbmcgaW5vKQogewog
CXN0cnVjdCBobGlzdF9ub2RlICpub2RlOwotCXN0cnVjdCBpbm9kZSAqIGlub2RlID0gTlVMTDsK
KwlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gTlVMTDsKIAogcmVwZWF0OgogCWhsaXN0X2Zvcl9lYWNo
X2VudHJ5KGlub2RlLCBub2RlLCBoZWFkLCBpX2hhc2gpIHsKQEAgLTYxNywxMCArNjE2LDEwIEBA
IHN0cnVjdCBpbm9kZSAqbmV3X2lub2RlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJICogaGVy
ZSB0byBhdHRlbXB0IHRvIGF2b2lkIHRoYXQuCiAJICovCiAJc3RhdGljIHVuc2lnbmVkIGludCBs
YXN0X2lubzsKLQlzdHJ1Y3QgaW5vZGUgKiBpbm9kZTsKKwlzdHJ1Y3QgaW5vZGUgKmlub2RlOwog
CiAJc3Bpbl9sb2NrX3ByZWZldGNoKCZpbm9kZV9sb2NrKTsKLQkKKwogCWlub2RlID0gYWxsb2Nf
aW5vZGUoc2IpOwogCWlmIChpbm9kZSkgewogCQlzcGluX2xvY2soJmlub2RlX2xvY2spOwpAQCAt
NjMxLDcgKzYzMCw2IEBAIHN0cnVjdCBpbm9kZSAqbmV3X2lub2RlKHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IpCiAJfQogCXJldHVybiBpbm9kZTsKIH0KLQogRVhQT1JUX1NZTUJPTChuZXdfaW5vZGUp
OwogCiB2b2lkIHVubG9ja19uZXdfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKQEAgLTY1OSw3
ICs2NTcsNiBAQCB2b2lkIHVubG9ja19uZXdfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKIAlp
bm9kZS0+aV9zdGF0ZSAmPSB+KElfTE9DS3xJX05FVyk7CiAJd2FrZV91cF9pbm9kZShpbm9kZSk7
CiB9Ci0KIEVYUE9SVF9TWU1CT0wodW5sb2NrX25ld19pbm9kZSk7CiAKIC8qCkBAIC02NjgsMTMg
KzY2NSwxNiBAQCBFWFBPUlRfU1lNQk9MKHVubG9ja19uZXdfaW5vZGUpOwogICogV2Ugbm8gbG9u
Z2VyIGNhY2hlIHRoZSBzYl9mbGFncyBpbiBpX2ZsYWdzIC0gc2VlIGZzLmgKICAqCS0tIHJta0Bh
cm0udWsubGludXgub3JnCiAgKi8KLXN0YXRpYyBzdHJ1Y3QgaW5vZGUgKiBnZXRfbmV3X2lub2Rl
KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBobGlzdF9oZWFkICpoZWFkLCBpbnQgKCp0
ZXN0KShzdHJ1Y3QgaW5vZGUgKiwgdm9pZCAqKSwgaW50ICgqc2V0KShzdHJ1Y3QgaW5vZGUgKiwg
dm9pZCAqKSwgdm9pZCAqZGF0YSkKK3N0YXRpYyBzdHJ1Y3QgaW5vZGUgKmdldF9uZXdfaW5vZGUo
c3RydWN0IHN1cGVyX2Jsb2NrICpzYiwKKwkJCQlzdHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCwKKwkJ
CQlpbnQgKCp0ZXN0KShzdHJ1Y3QgaW5vZGUgKiwgdm9pZCAqKSwKKwkJCQlpbnQgKCpzZXQpKHN0
cnVjdCBpbm9kZSAqLCB2b2lkICopLCB2b2lkICpkYXRhKQogewotCXN0cnVjdCBpbm9kZSAqIGlu
b2RlOworCXN0cnVjdCBpbm9kZSAqaW5vZGU7CiAKIAlpbm9kZSA9IGFsbG9jX2lub2RlKHNiKTsK
IAlpZiAoaW5vZGUpIHsKLQkJc3RydWN0IGlub2RlICogb2xkOworCQlzdHJ1Y3QgaW5vZGUgKm9s
ZDsKIAogCQlzcGluX2xvY2soJmlub2RlX2xvY2spOwogCQkvKiBXZSByZWxlYXNlZCB0aGUgbG9j
aywgc28uLiAqLwpAQCAtNzE2LDEzICs3MTYsMTQgQEAgc2V0X2ZhaWxlZDoKICAqIGdldF9uZXdf
aW5vZGVfZmFzdCBpcyB0aGUgZmFzdCBwYXRoIHZlcnNpb24gb2YgZ2V0X25ld19pbm9kZSwgc2Vl
IHRoZQogICogY29tbWVudCBhdCBpZ2V0X2xvY2tlZCBmb3IgZGV0YWlscy4KICAqLwotc3RhdGlj
IHN0cnVjdCBpbm9kZSAqIGdldF9uZXdfaW5vZGVfZmFzdChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LCBzdHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCwgdW5zaWduZWQgbG9uZyBpbm8pCitzdGF0aWMgc3Ry
dWN0IGlub2RlICpnZXRfbmV3X2lub2RlX2Zhc3Qoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwKKwkJ
CQlzdHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCwgdW5zaWduZWQgbG9uZyBpbm8pCiB7Ci0Jc3RydWN0
IGlub2RlICogaW5vZGU7CisJc3RydWN0IGlub2RlICppbm9kZTsKIAogCWlub2RlID0gYWxsb2Nf
aW5vZGUoc2IpOwogCWlmIChpbm9kZSkgewotCQlzdHJ1Y3QgaW5vZGUgKiBvbGQ7CisJCXN0cnVj
dCBpbm9kZSAqb2xkOwogCiAJCXNwaW5fbG9jaygmaW5vZGVfbG9jayk7CiAJCS8qIFdlIHJlbGVh
c2VkIHRoZSBsb2NrLCBzby4uICovCkBAIC04MDgsNyArODA5LDYgQEAgc3RydWN0IGlub2RlICpp
Z3JhYihzdHJ1Y3QgaW5vZGUgKmlub2RlKQogCXNwaW5fdW5sb2NrKCZpbm9kZV9sb2NrKTsKIAly
ZXR1cm4gaW5vZGU7CiB9Ci0KIEVYUE9SVF9TWU1CT0woaWdyYWIpOwogCiAvKioKQEAgLTkwOSw3
ICs5MDksNiBAQCBzdHJ1Y3QgaW5vZGUgKmlsb29rdXA1X25vd2FpdChzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiLCB1bnNpZ25lZCBsb25nIGhhc2h2YWwsCiAKIAlyZXR1cm4gaWZpbmQoc2IsIGhlYWQs
IHRlc3QsIGRhdGEsIDApOwogfQotCiBFWFBPUlRfU1lNQk9MKGlsb29rdXA1X25vd2FpdCk7CiAK
IC8qKgpAQCAtOTM4LDcgKzkzNyw2IEBAIHN0cnVjdCBpbm9kZSAqaWxvb2t1cDUoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYiwgdW5zaWduZWQgbG9uZyBoYXNodmFsLAogCiAJcmV0dXJuIGlmaW5kKHNi
LCBoZWFkLCB0ZXN0LCBkYXRhLCAxKTsKIH0KLQogRVhQT1JUX1NZTUJPTChpbG9va3VwNSk7CiAK
IC8qKgpAQCAtOTYxLDcgKzk1OSw2IEBAIHN0cnVjdCBpbm9kZSAqaWxvb2t1cChzdHJ1Y3Qgc3Vw
ZXJfYmxvY2sgKnNiLCB1bnNpZ25lZCBsb25nIGlubykKIAogCXJldHVybiBpZmluZF9mYXN0KHNi
LCBoZWFkLCBpbm8pOwogfQotCiBFWFBPUlRfU1lNQk9MKGlsb29rdXApOwogCiAvKioKQEAgLTEw
MDAsNyArOTk3LDYgQEAgc3RydWN0IGlub2RlICppZ2V0NV9sb2NrZWQoc3RydWN0IHN1cGVyX2Js
b2NrICpzYiwgdW5zaWduZWQgbG9uZyBoYXNodmFsLAogCSAqLwogCXJldHVybiBnZXRfbmV3X2lu
b2RlKHNiLCBoZWFkLCB0ZXN0LCBzZXQsIGRhdGEpOwogfQotCiBFWFBPUlRfU1lNQk9MKGlnZXQ1
X2xvY2tlZCk7CiAKIC8qKgpAQCAtMTAzMiw3ICsxMDI4LDYgQEAgc3RydWN0IGlub2RlICppZ2V0
X2xvY2tlZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB1bnNpZ25lZCBsb25nIGlubykKIAkgKi8K
IAlyZXR1cm4gZ2V0X25ld19pbm9kZV9mYXN0KHNiLCBoZWFkLCBpbm8pOwogfQotCiBFWFBPUlRf
U1lNQk9MKGlnZXRfbG9ja2VkKTsKIAogaW50IGluc2VydF9pbm9kZV9sb2NrZWQoc3RydWN0IGlu
b2RlICppbm9kZSkKQEAgLTEwNjEsNyArMTA1Niw2IEBAIGludCBpbnNlcnRfaW5vZGVfbG9ja2Vk
KHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJCWlwdXQob2xkKTsKIAl9CiB9Ci0KIEVYUE9SVF9TWU1C
T0woaW5zZXJ0X2lub2RlX2xvY2tlZCk7CiAKIGludCBpbnNlcnRfaW5vZGVfbG9ja2VkNChzdHJ1
Y3QgaW5vZGUgKmlub2RlLCB1bnNpZ25lZCBsb25nIGhhc2h2YWwsCkBAIC0xMDkxLDcgKzEwODUs
NiBAQCBpbnQgaW5zZXJ0X2lub2RlX2xvY2tlZDQoc3RydWN0IGlub2RlICppbm9kZSwgdW5zaWdu
ZWQgbG9uZyBoYXNodmFsLAogCQlpcHV0KG9sZCk7CiAJfQogfQotCiBFWFBPUlRfU1lNQk9MKGlu
c2VydF9pbm9kZV9sb2NrZWQ0KTsKIAogLyoqCkBAIC0xMTA5LDcgKzExMDIsNiBAQCB2b2lkIF9f
aW5zZXJ0X2lub2RlX2hhc2goc3RydWN0IGlub2RlICppbm9kZSwgdW5zaWduZWQgbG9uZyBoYXNo
dmFsKQogCWhsaXN0X2FkZF9oZWFkKCZpbm9kZS0+aV9oYXNoLCBoZWFkKTsKIAlzcGluX3VubG9j
aygmaW5vZGVfbG9jayk7CiB9Ci0KIEVYUE9SVF9TWU1CT0woX19pbnNlcnRfaW5vZGVfaGFzaCk7
CiAKIC8qKgpAQCAtMTEyNCw3ICsxMTE2LDYgQEAgdm9pZCByZW1vdmVfaW5vZGVfaGFzaChzdHJ1
Y3QgaW5vZGUgKmlub2RlKQogCWhsaXN0X2RlbF9pbml0KCZpbm9kZS0+aV9oYXNoKTsKIAlzcGlu
X3VubG9jaygmaW5vZGVfbG9jayk7CiB9Ci0KIEVYUE9SVF9TWU1CT0wocmVtb3ZlX2lub2RlX2hh
c2gpOwogCiAvKgpAQCAtMTE3MSw3ICsxMTYyLDYgQEAgdm9pZCBnZW5lcmljX2RlbGV0ZV9pbm9k
ZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogCUJVR19PTihpbm9kZS0+aV9zdGF0ZSAhPSBJX0NMRUFS
KTsKIAlkZXN0cm95X2lub2RlKGlub2RlKTsKIH0KLQogRVhQT1JUX1NZTUJPTChnZW5lcmljX2Rl
bGV0ZV9pbm9kZSk7CiAKIHN0YXRpYyB2b2lkIGdlbmVyaWNfZm9yZ2V0X2lub2RlKHN0cnVjdCBp
bm9kZSAqaW5vZGUpCkBAIC0xMjE4LDEyICsxMjA4LDExIEBAIHZvaWQgZ2VuZXJpY19kcm9wX2lu
b2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJZWxzZQogCQlnZW5lcmljX2ZvcmdldF9pbm9kZShp
bm9kZSk7CiB9Ci0KIEVYUE9SVF9TWU1CT0xfR1BMKGdlbmVyaWNfZHJvcF9pbm9kZSk7CiAKIC8q
CiAgKiBDYWxsZWQgd2hlbiB3ZSdyZSBkcm9wcGluZyB0aGUgbGFzdCByZWZlcmVuY2UKLSAqIHRv
IGFuIGlub2RlLiAKKyAqIHRvIGFuIGlub2RlLgogICoKICAqIENhbGwgdGhlIEZTICJkcm9wKCki
IGZ1bmN0aW9uLCBkZWZhdWx0aW5nIHRvCiAgKiB0aGUgbGVnYWN5IFVOSVggZmlsZXN5c3RlbSBi
ZWhhdmlvdXIuLgpAQCAtMTI0Myw3ICsxMjMyLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGlwdXRf
ZmluYWwoc3RydWN0IGlub2RlICppbm9kZSkKIH0KIAogLyoqCi0gKglpcHV0CS0gcHV0IGFuIGlu
b2RlIAorICoJaXB1dAktIHB1dCBhbiBpbm9kZQogICoJQGlub2RlOiBpbm9kZSB0byBwdXQKICAq
CiAgKglQdXRzIGFuIGlub2RlLCBkcm9wcGluZyBpdHMgdXNhZ2UgY291bnQuIElmIHRoZSBpbm9k
ZSB1c2UgY291bnQgaGl0cwpAQCAtMTI2MCw3ICsxMjQ5LDYgQEAgdm9pZCBpcHV0KHN0cnVjdCBp
bm9kZSAqaW5vZGUpCiAJCQlpcHV0X2ZpbmFsKGlub2RlKTsKIAl9CiB9Ci0KIEVYUE9SVF9TWU1C
T0woaXB1dCk7CiAKIC8qKgpAQCAtMTI3MSwxMCArMTI1OSwxMCBAQCBFWFBPUlRfU1lNQk9MKGlw
dXQpOwogICoJUmV0dXJucyB0aGUgYmxvY2sgbnVtYmVyIG9uIHRoZSBkZXZpY2UgaG9sZGluZyB0
aGUgaW5vZGUgdGhhdAogICoJaXMgdGhlIGRpc2sgYmxvY2sgbnVtYmVyIGZvciB0aGUgYmxvY2sg
b2YgdGhlIGZpbGUgcmVxdWVzdGVkLgogICoJVGhhdCBpcywgYXNrZWQgZm9yIGJsb2NrIDQgb2Yg
aW5vZGUgMSB0aGUgZnVuY3Rpb24gd2lsbCByZXR1cm4gdGhlCi0gKglkaXNrIGJsb2NrIHJlbGF0
aXZlIHRvIHRoZSBkaXNrIHN0YXJ0IHRoYXQgaG9sZHMgdGhhdCBibG9jayBvZiB0aGUgCisgKglk
aXNrIGJsb2NrIHJlbGF0aXZlIHRvIHRoZSBkaXNrIHN0YXJ0IHRoYXQgaG9sZHMgdGhhdCBibG9j
ayBvZiB0aGUKICAqCWZpbGUuCiAgKi8KLXNlY3Rvcl90IGJtYXAoc3RydWN0IGlub2RlICogaW5v
ZGUsIHNlY3Rvcl90IGJsb2NrKQorc2VjdG9yX3QgYm1hcChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
ZWN0b3JfdCBibG9jaykKIHsKIAlzZWN0b3JfdCByZXMgPSAwOwogCWlmIChpbm9kZS0+aV9tYXBw
aW5nLT5hX29wcy0+Ym1hcCkKQEAgLTEzNzcsNyArMTM2NSw2IEBAIHZvaWQgZmlsZV91cGRhdGVf
dGltZShzdHJ1Y3QgZmlsZSAqZmlsZSkKIAkJbWFya19pbm9kZV9kaXJ0eV9zeW5jKGlub2RlKTsK
IAltbnRfZHJvcF93cml0ZShmaWxlLT5mX3BhdGgubW50KTsKIH0KLQogRVhQT1JUX1NZTUJPTChm
aWxlX3VwZGF0ZV90aW1lKTsKIAogaW50IGlub2RlX25lZWRzX3N5bmMoc3RydWN0IGlub2RlICpp
bm9kZSkKQEAgLTEzODgsNyArMTM3NSw2IEBAIGludCBpbm9kZV9uZWVkc19zeW5jKHN0cnVjdCBp
bm9kZSAqaW5vZGUpCiAJCXJldHVybiAxOwogCXJldHVybiAwOwogfQotCiBFWFBPUlRfU1lNQk9M
KGlub2RlX25lZWRzX3N5bmMpOwogCiBpbnQgaW5vZGVfd2FpdCh2b2lkICp3b3JkKQotLSAKMS41
LjQuMwoK
--0016363ba868d4a41d04666676cf--
