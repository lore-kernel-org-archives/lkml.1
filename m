Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZDHLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZDHLnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZDHL2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37856 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184AbZDHL1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:55 -0400
X-Sasl-enc: SAaaNDG8ze+pc/pXMHKWe1rpPjWmGjYuFE4JwSDuPBoT 1239190074
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 51/56] sysv: Remove void casts
Date: Wed,  8 Apr 2009 12:22:23 +0100
Message-Id: <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/sysv/dir.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 56f6552..8a9f5a7 100644
--- a/fs/sysv/dir.c
+++ b/fs/sysv/dir.c
@@ -87,7 +87,7 @@ static int sysv_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 		if (IS_ERR(page))
 			continue;
-		kaddr = (char *)page_address(page);
+		kaddr = page_address(page);
 		de = (struct sysv_dir_entry *)(kaddr+offset);
 		limit = kaddr + PAGE_CACHE_SIZE - SYSV_DIRSIZE;
 		for ( ;(char*)de <= limit; de++) {
@@ -157,7 +157,7 @@ struct sysv_dir_entry *sysv_find_entry(struct dentry *dentry, struct page **res_
 		char *kaddr;
 		page = dir_get_page(dir, n);
 		if (!IS_ERR(page)) {
-			kaddr = (char*)page_address(page);
+			kaddr = page_address(page);
 			de = (struct sysv_dir_entry *) kaddr;
 			kaddr += PAGE_CACHE_SIZE - SYSV_DIRSIZE;
 			for ( ; (char *) de <= kaddr ; de++) {
@@ -201,7 +201,7 @@ int sysv_add_link(struct dentry *dentry, struct inode *inode)
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto out;
-		kaddr = (char*)page_address(page);
+		kaddr = page_address(page);
 		de = (struct sysv_dir_entry *)kaddr;
 		kaddr += PAGE_CACHE_SIZE - SYSV_DIRSIZE;
 		while ((char *)de <= kaddr) {
@@ -244,7 +244,7 @@ int sysv_delete_entry(struct sysv_dir_entry *de, struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = (struct inode*)mapping->host;
-	char *kaddr = (char*)page_address(page);
+	char *kaddr = page_address(page);
 	loff_t pos = page_offset(page) + (char *)de - kaddr;
 	int err;
 
@@ -278,7 +278,7 @@ int sysv_make_empty(struct inode *inode, struct inode *dir)
 	}
 	kmap(page);
 
-	base = (char*)page_address(page);
+	base = page_address(page);
 	memset(base, 0, PAGE_CACHE_SIZE);
 
 	de = (struct sysv_dir_entry *) base;
@@ -312,7 +312,7 @@ int sysv_empty_dir(struct inode * inode)
 		if (IS_ERR(page))
 			continue;
 
-		kaddr = (char *)page_address(page);
+		kaddr = page_address(page);
 		de = (struct sysv_dir_entry *)kaddr;
 		kaddr += PAGE_CACHE_SIZE-SYSV_DIRSIZE;
 
@@ -367,7 +367,7 @@ struct sysv_dir_entry * sysv_dotdot (struct inode *dir, struct page **p)
 	struct sysv_dir_entry *de = NULL;
 
 	if (!IS_ERR(page)) {
-		de = (struct sysv_dir_entry*) page_address(page) + 1;
+		de = page_address(page) + 1;
 		*p = page;
 	}
 	return de;
-- 
1.5.4.3

