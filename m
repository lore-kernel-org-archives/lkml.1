Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbXJ0DJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbXJ0DJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXJ0DJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:09:42 -0400
Received: from ro-out-1112.google.com ([72.14.202.177]:44187 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXJ0DJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=mmKHVA6RGMvhhFiWEPhYW9iRZ4OpmCcTZrJfO7y+fUSnM54j/hi6CLghbVfhipwUZqYtvr8kLxMHcYzOSuBh0zVjcd3Ki8EA6GULyIs4oVz+pCtljT3qNu9eH/lcPaaQniZd1459nrnzx7PEb9yAoBjlLRWIeEtC4AMGoaCCn70=
Date: Sat, 27 Oct 2007 11:04:55 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@karaya.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Git Patch]arch/um/drivers/ubd_kern.c: a warning fix
Message-ID: <20071027030455.GA2506@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix an incompatible-pointer warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index e184b44..7e6cdde 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -705,7 +705,7 @@ static int ubd_add(int n, char **error_out)
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
 	INIT_LIST_HEAD(&ubd_dev->restart);
-	sg_init_table(&ubd_dev->sg, MAX_SG);
+	sg_init_table(ubd_dev->sg, MAX_SG);
 
 	err = -ENOMEM;
 	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
