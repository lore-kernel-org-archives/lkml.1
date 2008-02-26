Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbYBZKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbYBZKZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYBZKZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:25:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14400 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854AbYBZKZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:25:33 -0500
Date: Tue, 26 Feb 2008 13:25:20 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: switch to proc_create()
Message-ID: <20080226102520.GF7469@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 crypto/proc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -99,11 +99,7 @@ static const struct file_operations proc_crypto_ops = {
 
 void __init crypto_init_proc(void)
 {
-	struct proc_dir_entry *proc;
-	
-	proc = create_proc_entry("crypto", 0, NULL);
-	if (proc)
-		proc->proc_fops = &proc_crypto_ops;
+	proc_create("crypto", 0, NULL, &proc_crypto_ops);
 }
 
 void __exit crypto_exit_proc(void)

