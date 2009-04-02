Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZDBLhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZDBLhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDBLhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:37:15 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:41345 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZDBLhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=uABtKVtb2CPzB7HlEgqNJBsvNXqj0B1dLeUDivH5flKZ+um78CndxYi7B9WKWsCyo1
         vL6WKDgmWKsp1jTtEBmvQZXUrnysl8oxTPNOxbNfgiQBMOTtPS0UX/53N0eZNcYGuOGB
         y+3b7l7f2GyUOBwExb8kLrulzJqRhz//4W4xo=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 15:37:10 +0400
Message-ID: <a4423d670904020437q446f7c62xa209822f10573c28@mail.gmail.com>
Subject: [PATCH] Staging: pohmelfs: should include fs_struct.h
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/pohmelfs/path_entry.c: In function
'pohmelfs_construct_path_string':
drivers/staging/pohmelfs/path_entry.c:48: error: dereferencing pointer
to incomplete type
drivers/staging/pohmelfs/path_entry.c:49: error: dereferencing pointer
to incomplete type
drivers/staging/pohmelfs/path_entry.c:50: error: dereferencing pointer
to incomplete type
drivers/staging/pohmelfs/path_entry.c: In function 'pohmelfs_path_length':
drivers/staging/pohmelfs/path_entry.c:95: error: dereferencing pointer
to incomplete type
drivers/staging/pohmelfs/path_entry.c:96: error: dereferencing pointer
to incomplete type
drivers/staging/pohmelfs/path_entry.c:97: error: dereferencing pointer
to incomplete type

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/pohmelfs/path_entry.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/pohmelfs/path_entry.c
b/drivers/staging/pohmelfs/path_entry.c
index 9270e54..3bad888 100644
--- a/drivers/staging/pohmelfs/path_entry.c
+++ b/drivers/staging/pohmelfs/path_entry.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/ktime.h>
-#include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/mount.h>
