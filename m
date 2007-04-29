Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbXD2K6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbXD2K6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXD2K5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:57:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342AbXD2Kxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [46/48] x86_64: adjust EDID retrieval
Message-Id: <20070429105336.CF2E2151CB@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
commit 5e518d7672dea4cd7c60871e40d0490c52f01d13 did the same change to
i386's variant.

With this change, i386's and x86-64's versions are identical, raising
the question whether the x86-64 one should go (just like there's only
one instance of edd.S).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/boot/video.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/boot/video.S
===================================================================
--- linux.orig/arch/x86_64/boot/video.S
+++ linux/arch/x86_64/boot/video.S
@@ -1977,7 +1977,7 @@ store_edid:
 	movw	$0x4f15, %ax                    # do VBE/DDC
 	movw	$0x01, %bx
 	movw	$0x00, %cx
-	movw    $0x01, %dx
+	movw    $0x00, %dx
 	movw	$0x140, %di
 	int	$0x10
 
