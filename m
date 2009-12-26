Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZLZRF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZLZRF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 12:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZLZRF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 12:05:26 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:51610 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZLZRFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 12:05:25 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] [KFIFO] Fix typo in comment
Date: Sat, 26 Dec 2009 18:05:24 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.85; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912261805.25080.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0daa838f60cb4ebf41885155f3144711f14a05c8 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Sat, 26 Dec 2009 17:58:11 +0100
Subject: [PATCH] [KFIFO] Fix typo in comment

It's DECLARE_KFIFO, not DECLARED_KFIFO.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 include/linux/kfifo.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 3d44e9c..7c6b32a 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -81,7 +81,7 @@ union { \
 }
 
 /**
- * INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
+ * INIT_KFIFO - Initialize a kfifo declared by DECLARE_KFIFO
  * @name: name of the declared kfifo datatype
  */
 #define INIT_KFIFO(name) \
-- 
1.6.4.2

