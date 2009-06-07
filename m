Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZFGITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZFGITy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZFGITk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:19:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:61797 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZFGITi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lyjwALSbruLV97ne0gFtz6x/rXBowmbdEMZrrBWqVtQxlipYsc0MaC1zsTKZE63dZb
         N79d7V/pyBKCt9pyAeMkructV82eD7ccfmyS60Cn3SZ9exkCs1d5W+F87snUIY5AB8eB
         VmsP305OmmPs13EHFBFfbHYqCYGNUNCf/VNVw=
Date: Sun, 7 Jun 2009 12:19:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] nmi: use predefined numbers instead of hardcoded one
Message-ID: <20090607081937.GC4547@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
I should have it done long time ago but anyway.

 arch/x86/include/asm/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/nmi.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/nmi.h
+++ linux-2.6.git/arch/x86/include/asm/nmi.h
@@ -64,7 +64,7 @@ static inline int nmi_watchdog_active(vo
 	 * but since they are power of two we could use a
 	 * cheaper way --cvg
 	 */
-	return nmi_watchdog & 0x3;
+	return nmi_watchdog & (NMI_LOCAL_APIC | NMI_IO_APIC);
 }
 #endif
 
