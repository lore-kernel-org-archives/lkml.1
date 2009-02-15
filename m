Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZBOSVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZBOSVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZBOSUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:8472 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZBOSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IzrScgNwyYatzkziGiYh420O3TtBYZyq7ak1DZBIr0Azk88ago0H3Q5kFaAc/9Atq8
         C+adsP9hHLlodJyWWZply01cn+Djfut4qzYr/wLJQWL4fJI7QOAe2/CmykigHL+68CAL
         nIoIQB/ij4whzLd8JqzHi1+xZW0gcaMIq6VwE=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/6] New option: Static linking of external modules
Date: Sun, 15 Feb 2009 19:20:23 +0100
Message-Id: <1234722028-8110-2-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define configuration option CONFIG_MODULE_STATIC.
---
 init/Kconfig |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f068071..dc0f5aa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1042,6 +1042,27 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config MODULE_STATIC
+	bool "Static module linking support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Your computer will start slightly faster if device drivers are
+	  built into the kernel rather than loaded as modules during the
+	  boot process.
+
+	  However, a specialized kernel is impractical to build if the target
+	  hardware configuration is unknown before installation, such as is
+	  the case with generic Linux distributions.
+
+	  If you say Y here, you can build external modules into the kernel,
+	  quickly and without a compiler and with less disk space needed
+	  compared to a fully compiled kernel source tree. Note that your
+	  modules must also be built with this option enabled.
+
+	  See <file:/Documentation/...TODO...> for more details.
+
+	  If unsure, say N.
+
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
-- 
1.5.6.3

