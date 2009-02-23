Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZBWUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZBWUC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZBWUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:15 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:38402 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZBWUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=X08AwMo+DNqEf96Q14GVX1RUeQc+h2lMJXEbUgt1kVZHbcTTkFa8Fyw/O36c8HqFeW
         sSoi+lIJZpqQS9uJ4sXm8E8TJCqke17co3GJx2BmJhdP4ZcWo+S6O4yVaab/mne9J6ru
         cI4nnYQOtjAWvO/Lm0rfxBRbWhp9JVYW8RhS8=
Message-Id: <20090223200226.693185140@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:56:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/6] x86: head_64.S - remove useless balign
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-remove-balign
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

NEXT_PAGE already has 'balign' so no
need to keep this redundant one.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

No functional change -- md5 sum remains the same.

 arch/x86/kernel/head_64.S |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S
+++ linux-2.6.git/arch/x86/kernel/head_64.S
@@ -329,8 +329,6 @@ early_idt_ripmsg:
 #endif /* CONFIG_EARLY_PRINTK */
 	.previous
 
-.balign PAGE_SIZE
-
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
 ENTRY(name)

