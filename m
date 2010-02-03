Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0BCUSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:18:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18597 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab0BCUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bXEQLcG0L4B53kWAkY48RTn8ilX9MlHo+yG4bAAc2mxXgywwbtkCWBZ4YNv6kMWslQ
         smNEpb6Dby6rmyna7meSQSQA9PB68QY01CREzBYwv6ZVW+kfZt2/tbin8ioks1kS0lAo
         jTAf/+4FK2SyUGcpT03hgSdipP6b7GG6s8zF4=
Date: Wed, 3 Feb 2010 22:18:17 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: [PATCH] tags: put function prototypes back!
Message-ID: <20100203201816.GA5987@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
"ctags: usability fix" removed function prototypes from tags file
claiming "It makes no real sense to include function prototypes".
But it is useful for quickly determining which header file developer
needs to include to fix compilation.

Now if someone wants to remove forward declatations (which I agree are
baggage), write a postprocessing script.

Please apply.

	Alexey, who is sick reverting this chunk locally.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -108,7 +108,7 @@ exuberant()
 	-I ____cacheline_internodealigned_in_smp                \
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
-	--extra=+f --c-kinds=-px                                \
+	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
 
