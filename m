Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbXGTWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbXGTWbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXGTWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:31:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43822 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXGTWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:31:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/4] kconfig: remove unused members from struct symbol
Date: Sat, 21 Jul 2007 00:30:44 +0200
Message-Id: <11849706441071-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11849706441498-git-send-email-sam@ravnborg.org>
References: <20070720222039.GA25443@uranus.ravnborg.org> <11849706443410-git-send-email-sam@ravnborg.org> <11849706441152-git-send-email-sam@ravnborg.org> <11849706441498-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dep and dep2 in struct symbol was unused - remove them.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/expr.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index d6c33ce..a195986 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -77,7 +77,6 @@ struct symbol {
 	tristate visible;
 	int flags;
 	struct property *prop;
-	struct expr *dep, *dep2;
 	struct expr_value rev_dep;
 };
 
-- 
1.5.0.6

