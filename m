Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZFEXuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZFEXuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZFEXmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:42:07 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36405 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZFEXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:10 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 11/39] kbuild, deb-pkg: improve Source field
Date: Sat,  6 Jun 2009 01:42:29 +0200
Message-Id: <1244245377-17441-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

The Source: field is defined as the source package in the package
archive from which a binary packages are built. As deb-pkg does not
generate a source package, we should avoid to use any existing source
packages here.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 9d464fd..6d3b7e5 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -114,7 +114,7 @@ maintainer="$name <$email>"
 
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
-linux ($packageversion) unstable; urgency=low
+linux-upstream ($packageversion) unstable; urgency=low
 
   * Custom built Linux kernel.
 
@@ -143,7 +143,7 @@ EOF
 
 # Generate a control file
 cat <<EOF > debian/control
-Source: linux
+Source: linux-upstream
 Section: base
 Priority: optional
 Maintainer: $maintainer
-- 
1.6.3.rc3.40.g75b44

