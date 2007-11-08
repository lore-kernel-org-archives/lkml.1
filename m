Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbXKHJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbXKHJko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXKHJkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:40:35 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:4142 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbXKHJke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=rWj8AYNpbF00f9orYIOYgfUahhBIva4HdHNBZwaPvyHbvHuBnG60YxlQKAuQt7gVr6mmuyuk+gFzn+A5qdk9z+7A/LLLPKPlAEM9T6pPmHSYQQRpYXnzbW4X5NePOLWE/Xo7b4uqAPP77O7Yj7s79opErUreVKoRTXeXcIkOsMs=
Date: Thu, 8 Nov 2007 17:39:06 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch](Resend) Makefile: Let 'make mrproper' clean ncscope.out
Message-ID: <20071108093906.GE2479@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove ncscope.out when `make mrproper'.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -1086,7 +1086,7 @@ MRPROPER_DIRS  += include/config include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers tags TAGS *cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
