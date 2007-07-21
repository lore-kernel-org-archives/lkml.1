Return-Path: <linux-kernel-owner+w=401wt.eu-S940575AbXGUPLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940575AbXGUPLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933444AbXGUPET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937614AbXGUPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=pKB3rOYwW7AlvKOihAlmHVBn+C7AyRJ1EYy4CsocI88W2EWF98u08CTJj6I/CWqG2XZ/zC2izXBggGrNys5Cdg+F7ta/zZerKLWI/5AsHtAqeLflkIsFmhaH3V6tWz6kylg+/iFeAn+E6pPXPMw9CW4gHOy5JiRjYn1JXwaO/tc=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][18/37] Clean up duplicate includes in fs/ecryptfs/
Date: Sat, 21 Jul 2007 17:03:18 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Michael A Halcrow <mahalcro@us.ibm.com>,
       Michael C Thompson <mcthomps@us.ibm.com>, Tyler Hicks <tyhicks@ou.edu>,
       ecryptfs-devel@lists.sourceforge.net,
       Mike Halcrow <mhalcrow@us.ibm.com>, phillip@hellewell.homeip.net
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.18898.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	fs/ecryptfs/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index e557a67..7a7cfc0 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -32,7 +32,6 @@
 #include <linux/crypto.h>
 #include <linux/netlink.h>
 #include <linux/mount.h>
-#include <linux/dcache.h>
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/parser.h>
