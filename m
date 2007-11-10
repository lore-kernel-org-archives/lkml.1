Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXKJUmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXKJUmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXKJUlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:41:52 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40905 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbXKJUlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:41:50 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: document make K64BIT=y in README
Date: Sat, 10 Nov 2007 21:43:28 +0100
Message-Id: <11947274092719-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11947274093213-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <11947274093213-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 README |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 159912c..6622ba1 100644
--- a/README
+++ b/README
@@ -194,6 +194,8 @@ CONFIGURING the kernel:
    "make *config" checks for a file named "all{yes/mod/no/random}.config"
    for symbol values that are to be forced.  If this file is not found,
    it checks for a file named "all.config" to contain forced values.
+   Finally it checks the environment variable K64BIT and set the config
+   symbol "64BIT" to the value of the K64BIT variable.
    
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
-- 
1.5.3.4.1157.g0e74-dirty

