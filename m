Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbXGIC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbXGIC7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXGIC7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:59:06 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:50706 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbXGIC7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:59:05 -0400
Date: Sun, 8 Jul 2007 22:59:01 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] SELinux: Use %lu for inode->i_no when printing avc
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082258410.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Oed <tobias.oed@octant-fr.com>

Inode numbers are unsigned long and so need to %lu as format string of printf.

Signed-off-by: Tobias Oed <tobias.oed@octant-fr.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index cc5fcef..78c408f 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -586,7 +586,7 @@ void avc_audit(u32 ssid, u32 tsid,
 				}
 			}
 			if (inode)
-				audit_log_format(ab, " dev=%s ino=%ld",
+				audit_log_format(ab, " dev=%s ino=%lu",
 						 inode->i_sb->s_id,
 						 inode->i_ino);
 			break;
-- 
1.5.0.6

