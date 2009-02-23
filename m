Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbZBWUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbZBWUDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbZBWUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:20 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55602 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZBWUCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=GCoN+IKgTnMW/luL6SlLv54YLAugy1bvdbE5g8zwwy3LSwS1iPhQwWvY/XBdVpdB5L
         EzDp+ksb6w/YNxSkVW1RMsmhX+l+heVszRO7tDpCxzGdRVL84ZkbZpcB9+hICxeq3DO1
         6OS33oOIYUD75hAKzLx1tED2GEBs7xR26XBDQ=
Message-Id: <20090223200226.851463507@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:56:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/6] x86: head_64.S - use IDT_ENTRIES instead of hardcoded number
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-use-IDT_ENTRIES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S
+++ linux-2.6.git/arch/x86/kernel/head_64.S
@@ -417,7 +417,7 @@ ENTRY(phys_base)
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
 ENTRY(idt_table)
-	.skip 256 * 16
+	.skip IDT_ENTRIES * 16
 
 	.section .bss.page_aligned, "aw", @nobits
 	.align PAGE_SIZE

