Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbZFOS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbZFOS66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZFOS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:58:50 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:38189 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFOS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:58:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Tue, 16 Jun 2009 03:58:48 +0900
Message-ID: <87d495fhnb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Those add the "errors=" option like ext*, and cleanup of ioctl.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Christoph Hellwig (1):
      fat: split fat_generic_ioctl

Denis Karpov (1):
      FAT: add 'errors' mount option

 Documentation/filesystems/vfat.txt |    5 +
 fs/fat/cache.c                     |    6 +-
 fs/fat/dir.c                       |    2 +-
 fs/fat/fat.h                       |    7 +-
 fs/fat/fatent.c                    |    4 +-
 fs/fat/file.c                      |  184 ++++++++++++++++++-----------------
 fs/fat/inode.c                     |   28 +++++-
 fs/fat/misc.c                      |   22 +++--
 fs/fat/namei_msdos.c               |    2 +-
 fs/fat/namei_vfat.c                |    2 +-
 10 files changed, 152 insertions(+), 110 deletions(-)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
