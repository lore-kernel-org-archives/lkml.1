Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874AbXFCUpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbXFCUpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXFCUpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:45:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55829 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXFCUpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:45:02 -0400
Date: Sun, 3 Jun 2007 22:46:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 05/19] kbuild: document cc-fullversion
Message-ID: <20070603204603.GE9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 05/19] kbuild: document cc-fullversion
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 28 May 2007 22:26:55 +0200

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index bb5306e..c6d9a35 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -501,6 +501,20 @@ more details, with real examples.
 	The third parameter may be a text as in this example, but it may also
 	be an expanded variable or a macro.
 
+    cc-fullversion
+	cc-fullversion is usefull when the exact version of gcc is needed.
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
+	the user why it stops.
 
 === 4 Host Program support
 
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
