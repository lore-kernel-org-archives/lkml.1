Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYJOOFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYJOOFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYJOOEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:48 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45077 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYJOOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:47 -0400
Subject: [PATCH 18/21] fat: Add printf attribute to fat_fs_panic()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:01 +0900
Message-ID: <e24598993e848f5f6e91822369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
	<6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
	<cd30496c3e848f5f6e81522369.ps@mail.parknet.co.jp>
	<056ecdb93e848f5f6e81622369.ps@mail.parknet.co.jp>
	<9562d38c3e848f5f6e81722369.ps@mail.parknet.co.jp>
In-Reply-To: <9562d38c3e848f5f6e81722369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fat/fat.h~fat-printk-attribute fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-printk-attribute	2008-09-29 10:26:20.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-09-29 10:26:20.000000000 +0900
@@ -308,7 +308,8 @@ extern int fat_fill_super(struct super_b
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
+extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3))) __cold;
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
_
