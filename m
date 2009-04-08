Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbZDHLXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbZDHLXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbZDHLWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60817 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbZDHLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:35 -0400
X-Sasl-enc: zfdZugbmpxJeYG2CPdy+WMQPI1vdwGq7m7B/RUrSiBbW 1239189754
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 02/56] alpha: Remove void casts
Date: Wed,  8 Apr 2009 12:21:34 +0100
Message-Id: <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/alpha/boot/bootpz.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 1036b51..6e7af60 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -129,7 +129,7 @@ pal_init(void)
 	pcb_va->flags = 1;
 	pcb_va->res1 = 0;
 	pcb_va->res2 = 0;
-	pcb_pa = (struct pcb_struct *)find_pa((unsigned long)pcb_va);
+	pcb_pa = find_pa((unsigned long)pcb_va);
 
 	/*
 	 * a0 = 2 (OSF)
-- 
1.5.4.3

