Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYIAE5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYIAE5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYIAE5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:57:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:49531 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYIAE5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tNMd/XVveL+EwuO8tdG265WCPLuwEJ1KejqzEgzm5UIAhM4czOFGk3mAylHHCfF9gx
         xU6qjymgBoX2NYwwl6mr5fOuaWhoWuGHqsSwsXBmj+WPiJGNY4Xgvh4k7R+NwdFRX/Gt
         WvWcVa/YmIiP8gHxYQGpxzkIlkGF0adJnI4+Y=
Date: Mon, 1 Sep 2008 08:59:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] COMPAT_BINFMT_ELF definition tweak
Message-ID: <20080901045918.GA17827@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't repeat BINFMT_ELF definition, simply multiply COMPAT and
BINFMT_ELF.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -25,7 +25,7 @@ config BINFMT_ELF
 
 config COMPAT_BINFMT_ELF
 	bool
-	depends on COMPAT && MMU
+	depends on COMPAT && BINFMT_ELF
 
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"

