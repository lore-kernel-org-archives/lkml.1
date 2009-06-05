Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZFEFOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZFEFOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFEFOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:14:12 -0400
Received: from neon.ftbfs.org ([83.168.236.214]:48043 "EHLO neon.ftbfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZFEFOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:14:11 -0400
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 01:14:11 EDT
From: Matt Kraai <kraai@ftbfs.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Matt Kraai <kraai@ftbfs.org>
Subject: [PATCH] Remove the hyphen from git commands
Date: Thu,  4 Jun 2009 21:43:10 -0700
Message-Id: <1244176990-14996-1-git-send-email-kraai@ftbfs.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Kraai <kraai@ftbfs.org>
---
 .gitignore                        |    2 +-
 Documentation/trace/kmemtrace.txt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

 Semi-recent versions of Git don't support a hyphen between "git" and
 the specific command, so remove them from examples that use them.

diff --git a/.gitignore b/.gitignore
index 51bd99d..caa8395 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,7 +3,7 @@
 # subdirectories here. Add them in the ".gitignore" file
 # in that subdirectory instead.
 #
-# NOTE! Please use 'git-ls-files -i --exclude-standard'
+# NOTE! Please use 'git ls-files -i --exclude-standard'
 # command after changing this file, to see if there are
 # any tracked files which get ignored after the change.
 #
diff --git a/Documentation/trace/kmemtrace.txt b/Documentation/trace/kmemtrace.txt
index a956d9b..6308735 100644
--- a/Documentation/trace/kmemtrace.txt
+++ b/Documentation/trace/kmemtrace.txt
@@ -64,7 +64,7 @@ III. Quick usage guide
 CONFIG_KMEMTRACE).
 
 2) Get the userspace tool and build it:
-$ git-clone git://repo.or.cz/kmemtrace-user.git		# current repository
+$ git clone git://repo.or.cz/kmemtrace-user.git		# current repository
 $ cd kmemtrace-user/
 $ ./autogen.sh
 $ ./configure
-- 
1.6.3.1

