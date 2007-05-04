Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXEDH5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXEDH5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXEDH5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:57:43 -0400
Received: from gw.ac.upc.edu ([147.83.30.3]:35413 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXEDH5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:57:42 -0400
Message-ID: <463AE774.7040004@ac.upc.edu>
Date: Fri, 04 May 2007 09:57:40 +0200
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Remove obsolete prototype
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The include/asm-powerpc/paca.h file has a prototype for a function that 
does not exist any more; its name is setup_boot_paca.  This function was 
removed in commit 4ba99b97dadd35b9ce1438b2bc7c992a4a14a8b1, so its 
prototype should have been removed at that time too.  Patch below.

Kind regards,


Signed-off-by: Julio M. Merino Vidal <jmerino@ac.upc.edu>

diff --git a/include/asm-powerpc/paca.h b/include/asm-powerpc/paca.h
index cf95274..00a70e5 100644
--- a/include/asm-powerpc/paca.h
+++ b/include/asm-powerpc/paca.h
@@ -107,7 +107,5 @@ struct paca_struct {
 
 extern struct paca_struct paca[];
 
-void setup_boot_paca(void);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_PACA_H */

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>

