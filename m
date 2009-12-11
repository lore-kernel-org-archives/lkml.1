Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbZLKEzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbZLKEzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760652AbZLKEyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:54:21 -0500
Received: from kroah.org ([198.145.64.141]:36814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910AbZLKEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:59 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:49 2009
Message-Id: <20091211042749.363249380@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.co.jp>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [31/90] ext4: Fix small typo for move_extent_per_page()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0031-ext4-Fix-small-typo-for-move_extent_per_page.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 44fc48f7048ab9657b524938a832fec4e0acea98)

This function means moving extents every page, so change its name from
move_exgtent_par_page().

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.co.jp>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -740,7 +740,7 @@ out:
  * on success, or a negative error value on failure.
  */
 static int
-move_extent_par_page(struct file *o_filp, struct inode *donor_inode,
+move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		  pgoff_t orig_page_offset, int data_offset_in_page,
 		  int block_len_in_page, int uninit)
 {
@@ -1267,7 +1267,7 @@ ext4_move_extents(struct file *o_filp, s
 		while (orig_page_offset <= seq_end_page) {
 
 			/* Swap original branches with new branches */
-			ret = move_extent_par_page(o_filp, donor_inode,
+			ret = move_extent_per_page(o_filp, donor_inode,
 						orig_page_offset,
 						data_offset_in_page,
 						block_len_in_page, uninit);


