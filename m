Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXKDPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXKDPKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXKDPKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:10:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:4906 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbXKDPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AO0y8gWU4FKhBAEamTm+X7OPb8FoxFtLQ/EwvD7macwyduqBcjLqNT2a4kTCggbGHmYIYe72UbXI86UmtbxvKHZ7Xak0pRzkbVrgdfs1o0bWgIHUNPspv/gK2iSxLwpQpTcKmY6xjSM6IWLGCQlB49FsL58p4DKiAFC0BGEdJsQ=
Message-ID: <e5bfff550711040710s1cb36692r183606a0122ebe51@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:10:34 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Remove a duplicated include in mm/filemap.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marco Costalba <mcostalba@gmail.com>
---
 mm/filemap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 188cf5f..0b360de 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -28,7 +28,6 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
-#include <linux/backing-dev.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/cpuset.h>
-- 
1.5.3.5.532.g5c38-dirty
