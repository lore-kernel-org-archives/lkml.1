Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXGQOK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXGQOK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762473AbXGQOH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55803 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760964AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 18/33] kbuild: warn about references from .init.text to .exit.text
Date: Tue, 17 Jul 2007 16:08:47 +0200
Message-Id: <11846813442297-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813444176-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The .exit.text section may be discarded either at build or at runtime.
So let modpost warn if this situation is detected.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1ef7875..7f5ff7e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1214,7 +1214,6 @@ static int exit_section_ref_ok(const char *name)
 		".exit.data",
 		".exit.text",
 		".exitcall.exit",
-		".init.text",
 		".rodata",
 		NULL
 	};
-- 
1.5.0.6

