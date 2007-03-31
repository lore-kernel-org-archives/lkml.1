Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXCaBVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXCaBVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXCaBVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:21:53 -0400
Received: from mbox.ssc.unict.it ([151.97.230.9]:53212 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbXCaBVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:21:45 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH] [PATCH] uml: fix static linking for real
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Date: Sat, 31 Mar 2007 03:20:27 +0200
Message-ID: <20070331012027.24884.85252.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There was a typo in commit 7632fc8f809a97f9d82ce125e8e3e579390ce2e5, preventing
it from working - 32bit binaries crashed hopelessly before the below fix and
work perfectly now.
Merge for 2.6.21, please.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 include/asm-um/common.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-um/common.lds.S b/include/asm-um/common.lds.S
index b16222b..f5de80c 100644
--- a/include/asm-um/common.lds.S
+++ b/include/asm-um/common.lds.S
@@ -15,7 +15,7 @@
   PROVIDE (_unprotected_end = .);
 
   . = ALIGN(4096);
-  .note : { *(note.*) }
+  .note : { *(.note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;



