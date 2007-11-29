Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbXK2TqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbXK2TqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbXK2Tpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:45:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbXK2Tpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:45:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=G1PfhHETW6ZgCNOjPgGWWUTC31ftSOItIXWkcfeGaTDqRGsRa3qQmf1BIe0HogO3gcqCzxeVIqIRIkqWGNzwerWpMkQqoB8GyzFU83CiivbFLnADW6S/800XS3BeHjC2eNJfkdTp04gOdM69QnErRBntXijyacR8poqATn90aL4=
Date: Thu, 29 Nov 2007 22:46:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/5] PPC cleanup: 82xx - do use for_each macro
Message-ID: <20071129194613.GD12123@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/82xx/pq2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
index a497cba..9e74393 100644
--- a/arch/powerpc/platforms/82xx/pq2.c
+++ b/arch/powerpc/platforms/82xx/pq2.c
@@ -72,11 +72,11 @@ err:
 
 void __init pq2_init_pci(void)
 {
-	struct device_node *np = NULL;
+	struct device_node *np;
 
 	ppc_md.pci_exclude_device = pq2_pci_exclude_device;
 
-	while ((np = of_find_compatible_node(np, NULL, "fsl,pq2-pci")))
+	for_each_compatible_node(np, NULL, "fsl,pq2-pci")
 		pq2_pci_add_bridge(np);
 }
 #endif
-- 
1.5.3.5
