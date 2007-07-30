Return-Path: <linux-kernel-owner+w=401wt.eu-S967966AbXG3TJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967966AbXG3TJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968154AbXG3TJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:09:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:7747 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968147AbXG3TI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZwQKM6+6WjBbcERIw9u/NuCYL9/+ZOTpW3F+bKxUNha9+7im6cGb6wNvtvlw+yv+mTHP+MxYedhcmxhDk/CIMSs4Vh8KNoBRhqqfvHxtbEaTq83QaeA+46736ZIdmC0/l1+W60WazfeBytysr2QnUgO3+vhlDllahyap9IwPsFw=
Date: Mon, 30 Jul 2007 23:08:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: [PATCH] Fallout from "Remove fs.h from mm.h" patch
Message-ID: <20070730190846.GC5776@martell.zuzino.mipt.ru>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While I was busy compile-testing my patch, ENOSYS sneaked into pm.h leading to some
compile-breakages mostly on ia64 and some mips configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/pm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -25,6 +25,7 @@
 
 #include <linux/list.h>
 #include <asm/atomic.h>
+#include <asm/errno.h>
 
 /*
  * Power management requests... these are passed to pm_send_all() and friends.

