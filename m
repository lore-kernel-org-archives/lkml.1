Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZDFVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZDFVCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbZDFVC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:02:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46333 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711AbZDFVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:02:27 -0400
Date: Mon, 6 Apr 2009 22:01:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yuri Tikhonov <yur@emcraft.com>, yanok@emcraft.com, prodyuth@gmail.com,
       jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
In-Reply-To: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
let powerpc 256kB pages coexist with CONFIG_SHMEM again.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Added linuxppc-dev and some other Cc's for this 3/3: sorry
if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.

 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.29-git13/arch/powerpc/Kconfig	2009-04-06 11:47:57.000000000 +0100
+++ linux/arch/powerpc/Kconfig	2009-04-06 18:18:47.000000000 +0100
@@ -462,7 +462,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size" if 44x
-	depends on !STDBINUTILS && (!SHMEM || BROKEN)
+	depends on !STDBINUTILS
 	help
 	  Make the page size 256k.
 
