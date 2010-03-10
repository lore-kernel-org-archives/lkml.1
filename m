Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0CJPFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:05:22 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:43420 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0CJPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:05:21 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] fatfs-2.6 fixes patches
Date: Thu, 11 Mar 2010 00:05:17 +0900
Message-ID: <874oko1aky.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is two fixes patch for fatfs.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Kevin Dankwardt (1):
      fat: Fix stat->f_namelen

OGAWA Hirofumi (1):
      fat: Fix vfat_lookup()

 fs/fat/inode.c           |    2 +-
 fs/fat/namei_vfat.c      |   27 +++++++++++++++++++--------
 include/linux/msdos_fs.h |    3 ++-
 3 files changed, 22 insertions(+), 10 deletions(-)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
