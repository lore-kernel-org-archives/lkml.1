Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbZJaOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbZJaOUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 10:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZJaOUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 10:20:22 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50890 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbZJaOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 10:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=H+wOVDT8GX/lcDA13gnbZhJVm76PhhdaG1w9cIx7IEW9RXef7TUMK3xBwIXFf5Tfxm
         BaOw5/dn6kqZsu4UZ294ztVxorcE1QL23gy/kk9eKxSI5Z1okCoMJGmvFvlka1Zfr5Zp
         c577rmzWgx/Ewh4GYzYLAn9ayn7G91Z3nrG/Y=
Date: Sat, 31 Oct 2009 17:20:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: [PATCH] tags: put function prototypes back
Message-ID: <20091031142020.GA8439@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having function prototypes in tags is useful for quick look
re which header is needed for compile fix.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -102,7 +102,7 @@ exuberant()
 	-I ____cacheline_internodealigned_in_smp                \
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
-	--extra=+f --c-kinds=-px                                \
+	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
 
