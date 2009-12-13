Return-Path: <linux-kernel-owner+w=401wt.eu-S1750847AbZLMXYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847AbZLMXYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZLMXYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:24:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36740 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZLMXYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:24:31 -0500
Date: Mon, 14 Dec 2009 10:24:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the md-current tree with Linus' tree
Message-Id: <20091214102428.f50557a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Today's linux-next merge of the md-current tree got a conflict in
fs/compat_ioctl.c between commit 789f0f89118a80a3ff5309371e5820f623ed2a53
("compat_ioctl: simplify calling of handlers") from Linus' tree and
commit 22cc6029b064a3232d6b5a7c03c805ba02afc6db ("md: move compat_ioctl
handling into md.c") from the md-current tree.

I fixed it up (see below) and can carry the fix for a while  (a merge
with Linus' tree should fix it).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/compat_ioctl.c
index 278020d,ad485ba..0000000
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@@ -979,29 -1912,22 +979,11 @@@ COMPATIBLE_IOCTL(FIGETBSZ
  /* 'X' - originally XFS but some now in the VFS */
  COMPATIBLE_IOCTL(FIFREEZE)
  COMPATIBLE_IOCTL(FITHAW)
- /* RAID */
- COMPATIBLE_IOCTL(RAID_VERSION)
- COMPATIBLE_IOCTL(GET_ARRAY_INFO)
- COMPATIBLE_IOCTL(GET_DISK_INFO)
- COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
- COMPATIBLE_IOCTL(RAID_AUTORUN)
- COMPATIBLE_IOCTL(CLEAR_ARRAY)
- COMPATIBLE_IOCTL(ADD_NEW_DISK)
- COMPATIBLE_IOCTL(SET_ARRAY_INFO)
- COMPATIBLE_IOCTL(SET_DISK_INFO)
- COMPATIBLE_IOCTL(WRITE_RAID_INFO)
- COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
- COMPATIBLE_IOCTL(PROTECT_ARRAY)
- COMPATIBLE_IOCTL(RUN_ARRAY)
- COMPATIBLE_IOCTL(STOP_ARRAY)
- COMPATIBLE_IOCTL(STOP_ARRAY_RO)
- COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
- COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 -/* Big K */
 -COMPATIBLE_IOCTL(PIO_FONT)
 -COMPATIBLE_IOCTL(GIO_FONT)
 -COMPATIBLE_IOCTL(PIO_CMAP)
 -COMPATIBLE_IOCTL(GIO_CMAP)
 -ULONG_IOCTL(KDSIGACCEPT)
  COMPATIBLE_IOCTL(KDGETKEYCODE)
  COMPATIBLE_IOCTL(KDSETKEYCODE)
 -ULONG_IOCTL(KIOCSOUND)
 -ULONG_IOCTL(KDMKTONE)
  COMPATIBLE_IOCTL(KDGKBTYPE)
 -ULONG_IOCTL(KDSETMODE)
  COMPATIBLE_IOCTL(KDGETMODE)
 -ULONG_IOCTL(KDSKBMODE)
  COMPATIBLE_IOCTL(KDGKBMODE)
 -ULONG_IOCTL(KDSKBMETA)
  COMPATIBLE_IOCTL(KDGKBMETA)
  COMPATIBLE_IOCTL(KDGKBENT)
  COMPATIBLE_IOCTL(KDSKBENT)
