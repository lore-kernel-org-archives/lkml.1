Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYBEPmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYBEPmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYBEPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:39:29 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38787 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYBEPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:39:17 -0500
Message-Id: <20080205153912.155035312@de.ibm.com>
References: <20080205153835.337897404@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Feb 2008 16:38:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 06/18] Fix linker script.
Content-Disposition: inline; filename=006-ld-script.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this warning:
vmlinux: warning: allocated section `.text' not in segment

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/vmlinux.lds.S
+++ quilt-2.6/arch/s390/kernel/vmlinux.lds.S
@@ -35,7 +35,7 @@ SECTIONS
 		KPROBES_TEXT
 		*(.fixup)
 		*(.gnu.warning)
-	} = 0x0700
+	} :text = 0x0700
 
 	_etext = .;		/* End of text section */
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

