Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYJMKdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYJMKdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYJMKcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:32:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:54339 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYJMKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-disposition:subject:from:date:mime-version:to:cc
         :content-type:content-transfer-encoding:message-id;
        b=vwC5A1NWEfp6MaXW/oeXWcweTTcNRQTEJFLFcoq5Q8/ZpNP57jJX7kS0s290/x836l
         otaxKg93ODMMkkzJimUpU6y9n0aUDeGEeaCuJaSQwWyzeo8Y/IWbrW2XNwDBMiulSz3/
         iB/vjSVHjuo2l+VnJB0kLNN4TrC+seQ5IBVWo=
Content-Disposition: inline
Subject: [PATCH] fs/dcache.c: update comment of d_validate()
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Date: Mon, 13 Oct 2008 18:32:42 +0800
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810131832.42981.qhfeng.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameters @hash and @len have been removed since 2.4.3,
now just to delete them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index e7a1a99..af65426 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1456,8 +1456,6 @@ out:
  * d_validate - verify dentry provided from insecure source
  * @dentry: The dentry alleged to be valid child of @dparent
  * @dparent: The parent dentry (known to be valid)
- * @hash: Hash of the dentry
- * @len: Length of the name
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.
