Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbYJSIoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbYJSIoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 04:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYJSIoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 04:44:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:59446 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYJSIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 04:44:45 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Sun, 19 Oct 2008 13:21:33 +0300
Message-Id: <20081019102133.13977.59657.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS updates for 2.6.28
X-OriginalArrivalTime: 19 Oct 2008 08:44:07.0130 (UTC) FILETIME=[D908FBA0:01C931C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS updates from

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit 94aca1dac6f6d21f4b07e4864baf7768cabcc6e7:
  Linus Torvalds (1):
        Linux 2.6.27-rc8

Adrian Hunter (12):
      UBIFS: add bulk-read facility
      UBIFS: add no_chk_data_crc mount option
      UBIFS: improve znode splitting rules
      UBIFS: correct key comparison
      UBIFS: ensure data read beyond i_size is zeroed out correctly
      UBIFS: allow for sync_fs when read-only
      UBIFS: improve garbage collection
      UBIFS: fix bulk-read handling uptodate pages
      UBIFS: add more debugging messages for LPT
      UBIFS: correct condition to eliminate unecessary assignment
      UBIFS: check buffer length when scanning for LPT nodes
      UBIFS: do not read unnecessary bytes when unpacking bits

Artem Bityutskiy (10):
      UBIFS: add a print, fix comments and more minor stuff
      UBIFS: inline one-line functions
      UBIFS: check data CRC when in error state
      UBIFS: use bit-fields when possible
      UBIFS: fix races in bit-fields
      UBIFS: fix commentary
      UBIFS: update dbg_dump_inode
      UBIFS: correct comment for commit_on_unmount
      UBIFS: commit on sync_fs
      UBIFS: amend printk

Geert Uytterhoeven (1):
      UBIFS: fix ubifs_compress commentary

Hirofumi Nakagawa (1):
      UBIFS: remove unneeded unlikely()

Julien Brunel (1):
      UBIFS: use an IS_ERR test rather than a NULL test

 Documentation/filesystems/ubifs.txt |    9 +
 fs/ubifs/budget.c                   |   26 ++--
 fs/ubifs/compress.c                 |    2 -
 fs/ubifs/debug.c                    |   79 +++++++--
 fs/ubifs/debug.h                    |    6 +
 fs/ubifs/file.c                     |  260 ++++++++++++++++++++++++++
 fs/ubifs/find.c                     |    4 +-
 fs/ubifs/gc.c                       |   90 ++++++++--
 fs/ubifs/io.c                       |   12 +-
 fs/ubifs/key.h                      |   22 ++-
 fs/ubifs/lprops.c                   |   34 +----
 fs/ubifs/lpt.c                      |   48 ++++-
 fs/ubifs/lpt_commit.c               |  187 ++++++++++++++++++-
 fs/ubifs/misc.h                     |   27 +++
 fs/ubifs/scan.c                     |    2 +-
 fs/ubifs/super.c                    |  109 +++++++++--
 fs/ubifs/tnc.c                      |  345 ++++++++++++++++++++++++++++++++---
 fs/ubifs/tnc_misc.c                 |    4 +-
 fs/ubifs/ubifs-media.h              |    1 -
 fs/ubifs/ubifs.h                    |   85 +++++++--
 fs/ubifs/xattr.c                    |    2 +-
 21 files changed, 1187 insertions(+), 167 deletions(-)
