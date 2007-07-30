Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXG3H7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXG3H7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbXG3H7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:59:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:6978 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbXG3H7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:59:38 -0400
Date: Mon, 30 Jul 2007 11:59:27 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, shemminger@osdl.org, devel@openvz.org
Subject: [PATCH] Add CTL_PROC back
Message-ID: <20070730075927.GA21414@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit eab03ac7bd3e0da99eb9dc068772a85a5e3f3577 aka
"[PATCH] Get rid of /proc/sys/proc" was good commit except strace(1) compile
breakage it introduced:

	system.c:1581: error: 'CTL_PROC' undeclared here (not in a function)

So, add dummy enum back.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/sysctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -62,7 +62,7 @@ enum
 	CTL_KERN=1,		/* General kernel info and control */
 	CTL_VM=2,		/* VM management */
 	CTL_NET=3,		/* Networking */
-	/* was CTL_PROC */
+	CTL_PROC=4,		/* removal breaks strace(1) compilation */
 	CTL_FS=5,		/* Filesystems */
 	CTL_DEBUG=6,		/* Debugging */
 	CTL_DEV=7,		/* Devices */

