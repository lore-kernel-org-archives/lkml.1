Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbYJSHYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbYJSHYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 03:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYJSHY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 03:24:28 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:52655 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYJSHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 03:24:28 -0400
Date: Sun, 19 Oct 2008 05:24:21 -0200
From: =?iso-8859-1?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] trivial: fix documentation regarding default io scheduler
Message-ID: <20081019072419.GA21534@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current Kconfig.iosched documentation says that the default I/O
scheduler is the CFQ scheduler, but the default, if nothing is changed,
is the anticipatory scheduler.

This patch fixes the documentation.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

--- linux/block/Kconfig.iosched.old
+++ linux/block/Kconfig.iosched
@@ -19,7 +19,7 @@
 	  The anticipatory I/O scheduler is generally a good choice for most
 	  environments, but is quite large and complex when compared to the
 	  deadline I/O scheduler, it can also be slower in some cases
-	  especially some database loads.
+	  especially some database loads.  This is the default I/O scheduler.
 
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
@@ -38,7 +38,6 @@
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
 	  among all processes in the system. It should provide a fair
 	  working environment, suitable for desktop systems.
-	  This is the default I/O scheduler.
 
 choice
 	prompt "Default I/O scheduler"

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
