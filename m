Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZKVEVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZKVEVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZKVEVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:21:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33580 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbZKVEVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nta/0uKkGMt4fnD4xwU4F1ONbtV7hFxmH1KnB3PNQKMkZpr2ZPnm85OLnQHUJCzdTV
         CUGnYQvTRsuYQBxcEKexYHHzhjAe0BSedWskgjuEAmlEdXjPNByBXQRCfauSSeGViu3k
         46tbT8EPe5BPbmCSF3x2lS8aapKtMoxXIwyXc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 3/4] hw-breakpoints: Remove x86 specific headers from core file
Date: Sun, 22 Nov 2009 05:21:34 +0100
Message-Id: <1258863695-10464-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove asm/processor.h and asm/debugreg.h as these headers are not
used anymore in the hw-breakpoints core file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 9ea9414..b6d6fa2 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -40,12 +40,6 @@
 
 #include <linux/hw_breakpoint.h>
 
-#include <asm/processor.h>
-
-#ifdef CONFIG_X86
-#include <asm/debugreg.h>
-#endif
-
 /*
  * Constraints data
  */
-- 
1.6.2.3

