Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXFCUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXFCUne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXFCUn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:43:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58756 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXFCUn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:43:27 -0400
Date: Sun, 3 Jun 2007 22:44:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 01/19] kbuild: asm-offsets.h is now cleaned with O=.. builds
Message-ID: <20070603204428.GA9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 01/19] kbuild: asm-offsets.h is now cleaned with O=.. builds
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 28 May 2007 22:14:37 +0200

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
1.5.1.rc3.1544.g8a923
