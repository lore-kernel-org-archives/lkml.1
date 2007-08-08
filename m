Return-Path: <linux-kernel-owner+w=401wt.eu-S938032AbXHHVPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938032AbXHHVPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965021AbXHHVOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:14:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:31728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbXHHVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QOT+lsmUtzOyMM0xqK71vIIt+gIzIpUqbyGZSaSZrZVAhCCfVMmY32CECGq+KwfrhvQ9fuJtF1GtvOQ2JFgE9R6Kqvz5KrWlk+N8JjrtvXAAFYzg+iG3VAmuBKMc8dxszixrQTAxGZTcbNoRlwOlPSFTSQs0I5R97jZEnDWZcaA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] Fix format specifier in Documentation/vm/slabinfo.c
Date: Wed, 8 Aug 2007 23:12:29 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082312.30156.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a little problem in Documentation/vm/slabinfo.c
The code is using "%d" in a printf() call to print an 'unsigned long'.
This patch corrects it to use "%lu" instead.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/vm/slabinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index d4f21ff..1af7bd5 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -396,7 +396,7 @@ void report(struct slabinfo *s)
 	if (strcmp(s->name, "*") == 0)
 		return;
 
-	printf("\nSlabcache: %-20s  Aliases: %2d Order : %2d Objects: %d\n",
+	printf("\nSlabcache: %-20s  Aliases: %2d Order : %2d Objects: %lu\n",
 		s->name, s->aliases, s->order, s->objects);
 	if (s->hwcache_align)
 		printf("** Hardware cacheline aligned\n");


