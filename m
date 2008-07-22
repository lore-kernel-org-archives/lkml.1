Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbYGVFne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbYGVFne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYGVF0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:43387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbYGVF0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/79] uio-howto.tmpl: use unique output names
Date: Mon, 21 Jul 2008 22:19:29 -0700
Message-Id: <1216703983-21448-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The Userspace I/O HOWTO template sets two different sections with the same
html output name (about.html).  This clearly won't work, so change the
first one to a unique "aboutthis.html" to prevent clobbering.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index d799a26..df87d1b 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -75,7 +75,7 @@ GPL version 2.
 </bookinfo>
 
 <chapter id="aboutthisdoc">
-<?dbhtml filename="about.html"?>
+<?dbhtml filename="aboutthis.html"?>
 <title>About this document</title>
 
 <sect1 id="translations">
-- 
1.5.6.3

