Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbXLHUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbXLHUGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXLHUGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:06:39 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:34824 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbXLHUGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=ABg3ZNI8wDs7UqAn4w+why9uj+TuPnzCMYEUq4U5oRXpzewIyFFN5HuC/feVH6XF24+w2VABuyt4i7H1WVG0gO7WzG+1RwW9T8v2aK5fn1vChRqUfaWI+L4ebrMT+8pVxb1Q4yGvr3zJK7gu7rfxzDi3447x9vLxfRJHkZlZRV4=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ps3: "mm/Kconfig" fix
Date: Sat, 8 Dec 2007 21:06:46 +0100
User-Agent: KMail/1.9.7
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
References: <200712082030.11338.mboton@gmail.com>
In-Reply-To: <200712082030.11338.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712082106.46372.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch had another bug. This one works fine.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/mm/Kconfig b/mm/Kconfig
index 010a261..9ef9741 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -117,7 +117,7 @@ config SPARSEMEM_VMEMMAP_ENABLE
 
 config SPARSEMEM_VMEMMAP
 	bool "Sparse Memory virtual memmap"
-	depends on SPARSEMEM_VMEMMAP_ENABLE
+	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
 	default y
 	help
 	 SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise


-- 
	Miguel Botón
