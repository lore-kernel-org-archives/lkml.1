Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYINJm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYINJm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYINJmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:42:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINJmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ta5C5ORS0TVTp6aQSsVJZmEESNFQ1wre+Kprk1gd24Q5Vn1wm/dWfOcAq3jOGjwlXk
         uULQs4Q9NwBLhN3SEaO38efFbxYN4w5Ws2Zcc+3g1a4jtSZLJq3h4fEREju6DUXoJjp0
         5K05Iis8toigL8RJhWcJzBDcUlE+RO4lD/RkU=
Date: Sun, 14 Sep 2008 13:44:41 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: simpler SYSVIPC_COMPAT definition
Message-ID: <20080914094441.GA3538@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_64 part is entirely redundant.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1773,7 +1773,7 @@ config COMPAT_FOR_U64_ALIGNMENT
 
 config SYSVIPC_COMPAT
 	def_bool y
-	depends on X86_64 && COMPAT && SYSVIPC
+	depends on COMPAT && SYSVIPC
 
 endmenu
 
