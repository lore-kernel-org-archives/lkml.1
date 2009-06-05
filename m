Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZFEXow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZFEXow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZFEXlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:21 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45055 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbZFEXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 08/39] kbuild, deb-pkg: improve changelog entry and package descriptions
Date: Sat,  6 Jun 2009 01:42:26 +0200
Message-Id: <1244245377-17441-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c01f812..0449147 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -98,7 +98,7 @@ name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
 cat <<EOF > debian/changelog
 linux ($packageversion) unstable; urgency=low
 
-  * A standard release
+  * Custom built Linux kernel.
 
  -- $name  $(date -R)
 EOF
@@ -126,7 +126,7 @@ Description: User Mode Linux kernel, version $version
  many other things.
  .
  This package contains the Linux kernel, modules and corresponding other
- files version $version
+ files, version: $version.
 EOF
 
 else
@@ -138,7 +138,7 @@ Suggests: $fwpackagename
 Architecture: any
 Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
- files version $version
+ files, version: $version.
 EOF
 
 fi
@@ -152,7 +152,7 @@ if [ -e "$tmpdir/lib/firmware" ]; then
 Package: $fwpackagename
 Architecture: all
 Description: Linux kernel firmware, version $version
- This package contains firmware from the Linux kernel, version $version
+ This package contains firmware from the Linux kernel, version $version.
 EOF
 
 	create_package "$fwpackagename" "$fwdir"
-- 
1.6.3.rc3.40.g75b44

