Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbZFEXt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbZFEXt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZFEXmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:42:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36409 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: maximilian attems <max@stro.at>, Frans Pop <elendil@planet.nl>,
       Andres Salomon <dilinger@debian.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 14/39] kbuild, deb-pkg: fix Section field
Date: Sat,  6 Jun 2009 01:42:32 +0200
Message-Id: <1244245377-17441-14-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: maximilian attems <max@stro.at>

Section "base" has been removed, the base is defined by Priority field.

For Squeeze the section should be "kernel", but as that's not yet
supported for Sarge and Etch we stay with admin for now.

Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index e1dd189..9708d26 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -144,7 +144,7 @@ EOF
 # Generate a control file
 cat <<EOF > debian/control
 Source: linux-upstream
-Section: base
+Section: admin
 Priority: optional
 Maintainer: $maintainer
 Standards-Version: 3.6.1
-- 
1.6.3.rc3.40.g75b44

