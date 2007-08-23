Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXHWNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXHWNZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbXHWNZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:25:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:28703 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXHWNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:25:39 -0400
Date: Thu, 23 Aug 2007 17:25:14 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: rusty@rustcorp.com.au
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lguest should depend on CONFIG_FUTEX
Message-ID: <20070823132514.GD31289@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It uses get_futex_key().

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/lguest/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
+	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE && FUTEX
 	select LGUEST_GUEST
 	select HVC_DRIVER
 	---help---

