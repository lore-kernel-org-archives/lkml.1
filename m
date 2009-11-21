Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZKURwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZKURwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZKURwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:52:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45302 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbZKURwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:52:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qB8aErI9x/ygfzxeLY8yhVvIVdrunaQuHwJr9TUx9uOsgXoxZqZIB/If0amu2/AcSR
         v5LsEN332iVXZoB1x1ryk0HiBH62bm4Oidh9g2CYkr6pLOX5RKEhqf3r3XT3H0Ckej4l
         7SnYZZUteVtJyfco6+HBeMPjWlNYmzeycS9Qk=
Date: Sat, 21 Nov 2009 20:50:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stefani@seibold.net
Subject: [PATCH] tags: put function prototypes back (like in 2.6.31)
Message-ID: <20091121175058.GA2904@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having function prototypes in tags is useful for e.g. quick look
which header is needed for compile fix.

removed in commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
"ctags: usability fix"

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
 
