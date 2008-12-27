Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYL0UYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYL0UYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYL0UXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:23:38 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:59111 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYL0UXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:23:36 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp
Subject: [PATCH] Review request for fatfs-2.6.git
Date: Sun, 28 Dec 2008 05:17:22 +0900
Message-Id: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Mailer: git-send-email 1.6.0.5.dirty
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches was added to

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git

recently, and are going to merge at next window. Please review.

Christoph Hellwig (1):
  fat: make sure to set d_ops in fat_get_parent

OGAWA Hirofumi (2):
  fat: drop negative dentry on rename() path
  fat: fix duplicate addition of ->llseek handler

 fs/fat/dir.c        |    1 -
 fs/fat/inode.c      |    2 ++
 fs/fat/namei_vfat.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

