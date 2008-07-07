Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYGGKIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYGGKIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYGGKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:08:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYGGKIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:08:42 -0400
From: "Li Xiaodong" <lixd@cn.fujitsu.com>
To: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: [PATCH]remove_declaration
Date: Mon, 7 Jul 2008 18:04:09 +0800
Message-ID: <AEFD1C75C2D6496EB4B19CE6B33656F2@fujitsulixd>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001B_01C8E05B.DAD09E50"
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Thread-Index: AcjgGMxj5m1NO4MUT267hvPbkWrZ0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_001B_01C8E05B.DAD09E50
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

The implementation of gfs2_inode_attr_in is removed.
So remove its declaration.

Signed-off-by: Li Xiaodong <lixd@cn.fujitsu.com>

---
 fs/gfs2/inode.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h index 580da45..d2ddb84 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -72,7 +72,6 @@ static inline void gfs2_inum_out(const struct gfs2_inode
*ip,  }
 
 
-void gfs2_inode_attr_in(struct gfs2_inode *ip);  void gfs2_set_iop(struct
inode *inode);  struct inode *gfs2_inode_lookup(struct super_block *sb,
unsigned type, 
 				u64 no_addr, u64 no_formal_ino,
--
1.5.5.1

------=_NextPart_000_001B_01C8E05B.DAD09E50
Content-Type: application/octet-stream;
	name="[PATCH]remove_declaration.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="[PATCH]remove_declaration.patch"

--- inode.h.bak	2008-07-08 01:57:04.000000000 +0800=0A=
+++ inode.h	2008-07-08 01:57:21.000000000 +0800=0A=
@@ -58,7 +58,6 @@ static inline void gfs2_inum_out(const s=0A=
 }=0A=
 =0A=
 =0A=
-void gfs2_inode_attr_in(struct gfs2_inode *ip);=0A=
 void gfs2_set_iop(struct inode *inode);=0A=
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,=0A=
 				u64 no_addr, u64 no_formal_ino,=0A=

------=_NextPart_000_001B_01C8E05B.DAD09E50--


