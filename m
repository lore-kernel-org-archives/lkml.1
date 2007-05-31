Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbXEaAa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbXEaAa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXEaAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:30:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59667 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbXEaAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:30:13 -0400
Message-Id: <20070531003012.302019683@sgi.com>
References: <20070531002047.702473071@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 17:20:48 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [RFC 1/4] CONFIG_STABLE: Define it
Content-Disposition: inline; filename=stable_init
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_STABLE to control checks only useful for development.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 init/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

Index: slub/init/Kconfig
===================================================================
--- slub.orig/init/Kconfig	2007-05-30 16:35:05.000000000 -0700
+++ slub/init/Kconfig	2007-05-30 16:35:45.000000000 -0700
@@ -65,6 +65,13 @@ endmenu
 
 menu "General setup"
 
+config STABLE
+	bool "Stable kernel"
+	help
+	  If the kernel is configured to be a stable kernel then various
+	  checks that are only of interest to kernel development will be
+	  omitted.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help

-- 
