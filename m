Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbZHHI50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbZHHI50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbZHHI5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 04:57:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:49965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963AbZHHI5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 04:57:24 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] documentation: register ioctl entry of nilfs2
Date: Sat,  8 Aug 2009 17:52:50 +0900
Message-Id: <1249721570-5692-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 08 Aug 2009 17:56:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will register the ioctl range used by nilfs2 file system to the
table listed in Documentation/ioctl/ioctl-number.txt.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 7bb0d93..dbea4f9 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -139,6 +139,7 @@ Code	Seq#	Include File		Comments
 'm'	all	linux/synclink.h	conflict!
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h
+'n'	80-8F	linux/nilfs2_fs.h	NILFS2
 'n'	E0-FF	video/matrox.h          matroxfb
 'o'	00-1F	fs/ocfs2/ocfs2_fs.h	OCFS2
 'o'     00-03   include/mtd/ubi-user.h  conflict! (OCFS2 and UBI overlaps)
-- 
1.6.3.4

