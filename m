Return-Path: <linux-kernel-owner+w=401wt.eu-S938830AbXHLU62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938830AbXHLU62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761202AbXHLU6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:58:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54230 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935489AbXHLU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JGwb2I1LPqnPQl9voWFigoMLgKQMLVQGNyXGFlmBTSPAbR2hayDdYTckmH2GfqDUaA/SeQqYdA9CRasbe4ZlpQbU6SIk+ATY+jQtvHMTAT77KnA4lkf/XdsHMtNyiREKw9wwi+nly6lgX/cHw2tMBsUitYF2i8ZG1hKlQwSuids=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] 4KSTACKS, make 'default y', -mm patch only.
Date: Sun, 12 Aug 2007 22:55:40 +0200
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
Message-Id: <200708122255.40547.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


To get more testing of 4K Stacks, make the feature 'default y'.

note: this patch is *NOT* intended for mainline atm, only for -mm.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index d4988cd..15b1a25 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -924,6 +924,7 @@ config COMPAT_VDSO
 
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
+	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates


