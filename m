Return-Path: <linux-kernel-owner+w=401wt.eu-S935566AbYBVAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566AbYBVAgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbYBVAge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:36:34 -0500
Received: from c60.cesmail.net ([216.154.195.49]:41303 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237AbYBVAgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:36:33 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] kbuild: CONFIG_CC_OPTIMIZE_FOR_SIZE should not be default
To: linux-kernel@vger.kernel.org
Date: Thu, 21 Feb 2008 19:36:31 -0500
Message-ID: <20080222003631.14308.32203.stgit@dv.roinet.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's an experimental option and it's not generally recommended

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index dcef8b5..a998a13 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -477,7 +477,6 @@ endif
 
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size (Look out for broken compilers!)"
-	default y
 	depends on ARM || H8300 || SUPERH || EXPERIMENTAL
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to gcc
