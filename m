Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXCEVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXCEVuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXCEVuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:50:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2695 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbXCEVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fidk2tXExYLRoZ4yNohSwFIGaGtDunr7X4F241irwhOYHGa88BzwAPhxRVF5t1GMwR76mDhaW5y/Lgrf2zn6kZgeYh/+UHrQ8XhZz8Hm6ciVIm5AnIAJa8uTZQNX3EnBaR4XCep7//ttYOQw7xUddIGiEysawF5qI5lZqFTVsDU=
Date: Tue, 6 Mar 2007 00:50:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] geode-aes: use unsigned long for spin_lock_irqsave
Message-ID: <20070305215056.GA5522@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/crypto/geode-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -101,7 +101,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 {
 
 	u32 flags = 0;
-	int iflags;
+	unsigned long iflags;
 
 	if (op->len == 0 || op->src == op->dst)
 		return 0;

