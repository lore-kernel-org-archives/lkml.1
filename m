Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbYF3S4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbYF3S4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763806AbYF3S43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:56:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:3115 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762046AbYF3S42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=WsnnJUuuY+WJTWhI57TXcL3412iC20niMgxlClZNVi7dWVz87ZMtAhwcEEcVlH8D/G
         5UzPbb5zxFI6b8sVPLBRDeuSme+bTe1fIAM5bLY0MM23tRJ0djxkrj55OpQQFu4bkMjR
         wl7l+Sqvw6l0JjwuUsgMpIzNEQ3nXgV7gyevk=
Message-ID: <ea11fea30806301156vadc53fenfbfc0ed6978e456@mail.gmail.com>
Date: Tue, 1 Jul 2008 00:26:14 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] ext2 : Use __func__ for function names in ext2_error messages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

============================================================

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

---
 fs/ext2/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index a78c6b4..bf3c467 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -146,7 +146,7 @@ out:
        /* Too bad, we had an error */

 Ebadsize:
-       ext2_error(sb, "ext2_check_page",
+       ext2_error(sb, __func__,
                "size of directory #%lu is not a multiple of chunk size",
                dir->i_ino
        );
@@ -166,7 +166,7 @@ Espan:
 Einumber:
        error = "inode out of bounds";
 bad_entry:
-       ext2_error (sb, "ext2_check_page", "bad entry in directory #%lu: %s - "
+       ext2_error (sb, __func__, "bad entry in directory #%lu: %s - "
                "offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
                dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
                (unsigned long) le32_to_cpu(p->inode),
@@ -174,7 +174,7 @@ bad_entry:
        goto fail;
 Eend:
        p = (ext2_dirent *)(kaddr + offs);
-       ext2_error (sb, "ext2_check_page",
+	ext2_error (sb, __func__,
 		"entry in directory #%lu spans the page boundary"
 		"offset=%lu, inode=%lu",
 		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
-- 
1.5.4.3

=================================================================
-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
