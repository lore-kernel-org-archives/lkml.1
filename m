Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbXGQOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbXGQOJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXGQOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35910 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760772AbXGQOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 04/33] kbuild: document cc-fullversion
Date: Tue, 17 Jul 2007 16:08:33 +0200
Message-Id: <11846813433593-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681343138-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index bb5306e..e08ef87 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -501,6 +501,20 @@ more details, with real examples.
 	The third parameter may be a text as in this example, but it may also
 	be an expanded variable or a macro.
 
+    cc-fullversion
+	cc-fullversion is useful when the exact version of gcc is needed.
+	One typical use-case is when a specific GCC version is broken.
+	cc-fullversion points out a more specific version than cc-version does.
+
+	Example:
+		#arch/powerpc/Makefile
+		$(Q)if test "$(call cc-fullversion)" = "040200" ; then \
+			echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
+			false ; \
+		fi
+
+	In this example for a specific GCC version the build will error out explaining
+	to the user why it stops.
 
 === 4 Host Program support
 
-- 
1.5.0.6

