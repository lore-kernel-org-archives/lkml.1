Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYGSBHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYGSBHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYGSBG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:06:56 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:46686 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbYGSBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:06:56 -0400
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 21:06:55 EDT
Date: Sat, 19 Jul 2008 01:50:15 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH,TRIVIAL] Fix typo in Hurd part of include/linux/ext2_fs.h
Message-ID: <20080719005015.GA400@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in Hurd part of include/linux/ext2_fs.h

The ';' here is redundant or can even pose problem.
This is actually not used by the Linux kernel, but it is exposed in
GNU/Hurd.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 84cec2a..2efe7b8 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -284,8 +284,8 @@ struct ext2_inode {
 
 #ifdef	__hurd__
 #define i_translator	osd1.hurd1.h_i_translator
-#define i_frag		osd2.hurd2.h_i_frag;
-#define i_fsize		osd2.hurd2.h_i_fsize;
+#define i_frag		osd2.hurd2.h_i_frag
+#define i_fsize		osd2.hurd2.h_i_fsize
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
 #define i_author	osd2.hurd2.h_i_author
