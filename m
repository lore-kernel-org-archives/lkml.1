Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbXGQOIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbXGQOIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760822AbXGQOHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35906 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXGQOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 01/33] kbuild: asm-offsets.h is now cleaned with O=.. builds
Date: Tue, 17 Jul 2007 16:08:30 +0200
Message-Id: <11846813423231-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: 20070717140622.GA25846@uranus.ravnborg.org
References: 20070717140622.GA25846@uranus.ravnborg.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
---
 Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Kbuild b/Kbuild
index 163f8cb..56b8edf 100644
--- a/Kbuild
+++ b/Kbuild
@@ -13,6 +13,7 @@ offsets-file := include/asm-$(ARCH)/asm-offsets.h
 always  := $(offsets-file)
 targets := $(offsets-file)
 targets += arch/$(ARCH)/kernel/asm-offsets.s
+clean-files := $(addprefix $(objtree)/,$(targets))
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
-- 
1.5.0.6

