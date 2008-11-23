Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbYKWVZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbYKWVZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKWVZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:25:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:45356 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYKWVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=kTgw4TW2mo4ODxXRyXGRgkc0uRcUZA++9U+uENm7EcUgtN82AOv+IlViv8ol+Ic1LE
         WTsWt40+A54lrRyzwq2SMXuF8omxUTu1GePg1F644+ZJmHw7YIi2WmTpq7UKXC7YBr1Q
         3+94qI5qCSIixmIGFJ9/t5+cFjXJF09L+UqoI=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] fix comment style on mangle_path
Date: Sun, 23 Nov 2008 23:24:53 +0200
Message-Id: <1227475493-5429-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4929C5C8.7090008@oracle.com>
References: <4929C5C8.7090008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 fs/seq_file.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index f5b61cc..f03220d 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -358,10 +358,10 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 EXPORT_SYMBOL(seq_printf);
 
 /**
- * 	mangle_path - mangle and copy path to buffer beginning
- * 	@s - buffer start
- * 	@p - beginning of path in above buffer
- *      @esc - set of characters that need escaping
+ *	mangle_path -	mangle and copy path to buffer beginning
+ *	@s: buffer start
+ *	@p: beginning of path in above buffer
+ *	@esc: set of characters that need escaping
  *
  *      Copy the path from @p to @s, replacing each occurrence of character from
  *      @esc with usual octal escape.
-- 
1.5.6.5

