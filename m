Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbYDYUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbYDYUlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762586AbYDYUlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:41:10 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46780 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929AbYDYUlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:41:09 -0400
Date: Fri, 25 Apr 2008 23:40:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Richard Hacker <lerichi@gmx.net>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [2.6 patch] scripts/Makefile.modpost typo fix
Message-ID: <20080425204016.GB20630@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EVIUSER  ;-)

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c047b74be2c64a0a1458a407cc77f54e5ae136c2 diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 24b3c8f..a098a04 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -76,7 +76,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(iKBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \

