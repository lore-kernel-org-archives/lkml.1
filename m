Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbZLKEhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbZLKEhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762370AbZLKEh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:27 -0500
Received: from kroah.org ([198.145.64.141]:37101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760515AbZLKEgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:42 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:16 2009
Message-Id: <20091211042815.716499145@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [77/90] ext4: Return the PTR_ERR of the correct pointer in setup_new_group_blocks()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0077-ext4-Return-the-PTR_ERR-of-the-correct-pointer-in-se.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit c09eef305dd43846360944ad072f051f964fa383)

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -247,7 +247,7 @@ static int setup_new_group_blocks(struct
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(bh);
+			err = PTR_ERR(gdb);
 			goto exit_bh;
 		}
 		ext4_handle_dirty_metadata(handle, NULL, gdb);


