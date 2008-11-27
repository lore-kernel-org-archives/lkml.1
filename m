Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYK0Koj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYK0Koj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYK0KdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:16 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:47759 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYK0Kc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:26 -0500
Message-Id: <20081127103137.267899851@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:54 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 34/60] add new machine types to setup_hwcaps.
Content-Disposition: inline; filename=133-elf-platform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add the machine types for z9-bc, z10-ec and z10-bc to the elf_platform
detection in setup_hwcaps.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: quilt-2.6/arch/s390/kernel/setup.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/setup.c
+++ quilt-2.6/arch/s390/kernel/setup.c
@@ -722,8 +722,13 @@ static void __init setup_hwcaps(void)
 		strcpy(elf_platform, "z990");
 		break;
 	case 0x2094:
+	case 0x2096:
 		strcpy(elf_platform, "z9-109");
 		break;
+	case 0x2097:
+	case 0x2098:
+		strcpy(elf_platform, "z10");
+		break;
 	}
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

