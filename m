Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYCJASF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYCJASF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 20:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYCJARx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 20:17:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:36162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYCJARw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 20:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=OVw2k77H+DVGdivypoozZzR71PU57AgIKSSER6NYMkASzg5klBrxvgxgOgK0aZcghT/LvdutvrNuwHN7i2Dsu92HjebTpnhstrjrh88aOX+8U7s3fImGTasgJhYSTx4S15voGf5JEzIHGnVO8pHQSGdFNlbmLXR+4rVWWCSeCOo=
Date: Mon, 10 Mar 2008 01:12:08 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Linux memory management list <linux-mm@kvack.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Emil Medve <Emilian.Medve@Freescale.com>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Do not include linux/backing-dev.h twice inside
 mm/filemap.c
Message-ID: <alpine.LNX.1.00.0803100106370.7691@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't include linux/backing-dev.h twice in mm/filemap.c, it's pointless.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 filemap.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5c74b68..ab98557 100644
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
