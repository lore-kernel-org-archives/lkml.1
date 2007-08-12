Return-Path: <linux-kernel-owner+w=401wt.eu-S938311AbXHLUz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938311AbXHLUz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbXHLUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:55:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbXHLUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GKTghbuKjeNll9ZrDgMkNlUGzlKh9xp8Sfoyqr5yNt2slttl/GO4gHrLGNPsL5fyVc69KsFiVGK5/w7SZ22g+W5/3fnVYKZN7cojHKdf4HGZMT3zPq94ypsObt6YnAHO3EiRDou5iK8D24iazG8N8gN28WSBmAXAbuczO/QHv6Y=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] 4KSTACKS, remove DEBUG_KERNEL dependency for sh
Date: Sun, 12 Aug 2007 22:53:23 +0200
User-Agent: KMail/1.9.7
Cc: Paul Mundt <lethal@linux-sh.org>, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708122250.58773.jesper.juhl@gmail.com>
In-Reply-To: <200708122250.58773.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122253.24034.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


4K Stacks is no longer a debug feature, so remove the DEBUG_KERNEL
dependancy for 4KSTACKS for sh.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
index 52f6a99..5bb4bd7 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -74,7 +74,6 @@ config DEBUG_STACK_USAGE
 
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates


