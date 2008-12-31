Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYLaE0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYLaE0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYLaE03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:26:29 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:57145 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYLaE03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:26:29 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT pull] FAT fixes
Date: Wed, 31 Dec 2008 13:26:22 +0900
Message-ID: <878wpx2cnl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

The following are FAT fixes.

Christoph Hellwig (1):
      fat: make sure to set d_ops in fat_get_parent

OGAWA Hirofumi (2):
      fat: drop negative dentry on rename() path
      fat: fix duplicate addition of ->llseek handler

 fs/fat/dir.c        |    1 -
 fs/fat/inode.c      |    2 ++
 fs/fat/namei_vfat.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
