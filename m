Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXJ3LUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXJ3LUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXJ3LT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:19:58 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:38265 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbXJ3LT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:19:57 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 14/16] CRIS architecture: Correct compile errors
Date: Tue, 30 Oct 2007 12:19:47 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C4014F@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680549C7F0@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: Jesper Nilsson [mailto:jespern@axis.com] 
Sent: Tuesday, October 30, 2007 10:35 AM
To: Andrew Morton; Mikael Starvik; Jesper Nilsson;
linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] CRIS architecture: Correct compile errors


Include linux/param.h for HZ.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -urBb -X /h/jespern/.exclude_files
clean_linux-2.6.23/arch/cris/arch-v10/kernel/setup.c
linux-2.6.23/arch/cris/arch-v10/kernel/setup.c
--- clean_linux-2.6.23/arch/cris/arch-v10/kernel/setup.c	2007-10-09
22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/kernel/setup.c	2007-10-22
13:53:03.000000000 +0200
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_PROC_FS
 #define HAS_FPU		0x0001

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com

