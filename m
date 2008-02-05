Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYBEQ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYBEQ3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYBEQ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:29:11 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:12231 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYBEQ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ccZyovYewVhqEWLzarFxyFfZtZnkCSzeBcGT73fIrAipj3J6X3WCToRpWKscZayKMU3bnQHI0RDdQY//HU4ZnLFyl8JiwZHn8CqMfxzuRV/mZgWAkxI687cybc3ZMLyyc2s4ciY6zfxNwQgnePMAUpeLByDBwVy3il3uQKw1hYE=
Date: Wed, 6 Feb 2008 00:25:57 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@karaya.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [-mm Patch] arch/um/kernel/initrd.c: fix a missed conversion
	specifier
Message-ID: <20080205162557.GC2966@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a missed conversion specifier of a printk in
arch/um/kernel/initrd.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@karaya.com>

---

Index: linux/arch/um/kernel/initrd.c
===================================================================
--- linux.orig/arch/um/kernel/initrd.c
+++ linux/arch/um/kernel/initrd.c
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 
