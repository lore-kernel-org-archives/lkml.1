Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbXBSRBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbXBSRBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXBSRBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:01:47 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46785 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbXBSRBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:01:46 -0500
Date: Mon, 19 Feb 2007 11:01:44 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] file caps: allow file caps when capabilities are modules
Message-ID: <20070219170144.GC28412@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH -mm] file caps: allow file caps when capabilities are modules

The security/Kconfig was set up so that file capabilities were
not an option when capabilities were selected as a module.  Fix.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 security/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

ea8bfdc0811caad45edf08d95923809c9ed84538
diff --git a/security/Kconfig b/security/Kconfig
index 6d77f68..bc5b1be 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -90,7 +90,7 @@ config SECURITY_CAPABILITIES
 
 config SECURITY_FS_CAPABILITIES
 	bool "File POSIX Capabilities"
-	depends on SECURITY=n || SECURITY_CAPABILITIES=y
+	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
-- 
1.1.6
