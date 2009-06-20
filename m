Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZFTOYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZFTOYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZFTOYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:24:09 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:49908 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZFTOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:24:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Sat, 20 Jun 2009 23:24:04 +0900
Message-ID: <87ocsjnfuj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the mistake of probably copy-and-paste.
[since the patch is small, it is attached for review]

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

OGAWA Hirofumi (1):
      fat: Fix the removal of opts->fs_dmask

 fs/fat/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff -puN fs/fat/inode.c~fat-fix-dmask-removal fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-fix-dmask-removal	2009-06-20 21:20:43.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2009-06-20 21:49:36.000000000 +0900
@@ -966,7 +966,7 @@ static int parse_options(char *options, 
 
 	opts->fs_uid = current_uid();
 	opts->fs_gid = current_gid();
-	opts->fs_fmask = current_umask();
+	opts->fs_fmask = opts->fs_dmask = current_umask();
 	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
