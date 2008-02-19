Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYBSOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYBSOdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBSOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:33:41 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:34456 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1750997AbYBSOdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:33:40 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 01:33:07 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 3/9]
Message-ID: <20080219143307.GA27352@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 3
> 	USER_NS
> 	PID_NS

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -211,21 +211,25 @@ config USER_NS
 	default n
 	depends on EXPERIMENTAL
 	help
-	  Support user namespaces.  This allows containers, i.e.
-	  vservers, to use user namespaces to provide different
-	  user info for different servers.  If unsure, say N.
+	  Enable support for user namespaces.
+
+	  This allows containers (i.e. vservers) to use user namespaces
+	  to provide different user info for different servers.
+
+	  If unsure, say N.
 
 config PID_NS
 	bool "PID Namespaces (EXPERIMENTAL)"
 	default n
 	depends on EXPERIMENTAL
 	help
-	  Suport process id namespaces.  This allows having multiple
-	  process with the same pid as long as they are in different
-	  pid namespaces.  This is a building block of containers.
+	  Enable support for process id namespaces.
 
-	  Unless you want to work with an experimental feature
-	  say N here.
+	  This allows having multiple processes with the same PID as
+	  long as they are in different PID namespaces.  This is used
+	  by containers (i.e. vservers).
+
+	  If unsure, say N.
 
 config AUDIT
 	bool "Auditing support"
