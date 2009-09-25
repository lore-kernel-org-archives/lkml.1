Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZIYOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZIYOCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZIYOCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:02:18 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58523 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZIYOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:02:17 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Fri, 25 Sep 2009 23:02:16 +0900
Message-ID: <87zl8jt95j.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

OGAWA Hirofumi (2):
      fat/nls: Fix handling of utf8 invalid char
      fat: Check s_dirt in fat_sync_fs()

Paul Wise (1):
      vfat: change the default from shortname=lower to shortname=mixed

 Documentation/filesystems/vfat.txt |    2 +-
 fs/fat/fat.h                       |    2 +-
 fs/fat/inode.c                     |   18 +++++++++++-------
 fs/fat/misc.c                      |    8 +++++---
 fs/fat/namei_vfat.c                |   15 ++++-----------
 fs/nls/nls_base.c                  |    8 ++++----
 6 files changed, 26 insertions(+), 27 deletions(-)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
