Return-Path: <linux-kernel-owner+w=401wt.eu-S940670AbXGUPNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940670AbXGUPNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939469AbXGUPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939467AbXGUPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=ZQR1Ij2DeEaIxDX8cvTy5S56ujNhIJ3V37x9wZD0CNKrLxH3ECzo1RDREQrtYWwwMZP8RcNhE/HNGrRH6ZJZM3vEjHrRLC4ytvsj3wgE9JPlDpZ/L0yOahOf5ON5hXnC6RFXMl+QA5kyY4zfuuoAzn6HUgULmDV6wsk2gd8+3lI=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rick Sladkey <jrs@world.std.com>, nfs@lists.sourceforge.net,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH][23/37] Clean up duplicate includes in include/linux/nfs_fs.h
Date: Sat, 21 Jul 2007 17:03:28 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.28932.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	include/linux/nfs_fs.h


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 9ba4aec..badc051 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -47,10 +47,8 @@
 #include <linux/nfs3.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_xdr.h>
-
 #include <linux/nfs_fs_sb.h>
 
-#include <linux/rwsem.h>
 #include <linux/mempool.h>
 
 /*
