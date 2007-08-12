Return-Path: <linux-kernel-owner+w=401wt.eu-S938021AbXHLUzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938021AbXHLUzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbXHLUyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:54:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51583 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbXHLUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EKyOF7+S+Js8YvuBnvBQDB7IlhbNRtHaM00Fkn21A33RM6LKYw5j7TB9U6LYzmR7IFHaSrrtvv1cxEKctoIWLTcG5ctJzcpdQZ39c9l8RaZsBFEWED11Of+fTggXL64TPefLTljZdprssAegybr0rrDLz27kndwBsCofFojaGwc=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] 4KSTACKS, remove DEBUG_KERNEL dependency for i386
Date: Sun, 12 Aug 2007 22:52:28 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708122250.58773.jesper.juhl@gmail.com>
In-Reply-To: <200708122250.58773.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122252.28235.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


4K Stacks is no longer a debug feature, so remove the DEBUG_KERNEL 
dependancy for 4KSTACKS for i386.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index f03531e..7131a16 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -58,7 +58,6 @@ config DEBUG_RODATA
 
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates


