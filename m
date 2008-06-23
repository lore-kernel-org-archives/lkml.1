Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYFWDS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYFWDS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYFWDSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:18:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52247 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYFWDSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:18:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: hjk@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] uio-howto.tmpl: use unique output names
Date: Sun, 22 Jun 2008 23:18:48 -0400
Message-Id: <1214191128-27114-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Userspace I/O HOWTO template sets two different sections with the same
html output name (about.html).  This clearly won't work, so change the first
one to a unique "aboutthis.html" to prevent clobbering.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/DocBook/uio-howto.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 3da4855..d38fbde 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -69,7 +69,7 @@ GPL version 2.
 </bookinfo>
 
 <chapter id="aboutthisdoc">
-<?dbhtml filename="about.html"?>
+<?dbhtml filename="aboutthis.html"?>
 <title>About this document</title>
 
 <sect1 id="translations">
-- 
1.5.5.3

