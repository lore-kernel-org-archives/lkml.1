Return-Path: <linux-kernel-owner+w=401wt.eu-S1765784AbXHFXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765784AbXHFXaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764390AbXHFX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:29:56 -0400
Received: from sp604003mt.neufgp.fr ([84.96.92.56]:53752 "EHLO smTp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764400AbXHFX3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:29:55 -0400
Date: Tue, 07 Aug 2007 00:29:40 +0200
From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] - Add "def_bool" Kconfig format documentation
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Reply-to: vincent.legoll@gmail.com
Message-id: <1186439380.21014.9.camel@quad>
MIME-version: 1.0
X-Mailer: Evolution 2.10.2
Content-type: text/plain
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is a small documentation patch for the KConfig file format
"def_bool" type definition that was missing.

I hope the patch is not mangled...

>From 4742eb7a3169001304524e82a88ec1c94f70aa56 Mon Sep 17 00:00:00 2001
From: Vincent Legoll <vincent.legoll@gmail.com>
Date: Sat, 4 Aug 2007 16:50:06 +0200
Subject: [PATCH] - Add "def_bool" Kconfig format documentation


Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 Documentation/kbuild/kconfig-language.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 536d5bf..27b8af9 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -77,6 +77,14 @@ applicable everywhere (see syntax).
   Optionally, dependencies only for this default value can be added
with
   "if".
 
+- boolean type definition with a default value: "def_bool" <expr>
+  So these two examples are equivalent:
+  
+    def_bool <expr>
+  and
+    bool
+    default <expr>
+  
 - dependencies: "depends on"/"requires" <expr>
   This defines a dependency for this menu entry. If multiple
   dependencies are defined, they are connected with '&&'. Dependencies
-- 
1.5.2.4



