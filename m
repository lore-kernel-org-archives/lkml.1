Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLKFaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLKFaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZLKFaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:30:05 -0500
Received: from kroah.org ([198.145.64.141]:53567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZLKFaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:02 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:54 2009
Message-Id: <20091211052553.749907435@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/34] ext4: Return the PTR_ERR of the correct pointer in setup_new_group_blocks()
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0021-ext4-Return-the-PTR_ERR-of-the-correct-pointer-in-se.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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


