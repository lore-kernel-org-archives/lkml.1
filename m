Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXFCUtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXFCUtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFCUrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53336 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbXFCUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:47 -0400
Date: Sun, 3 Jun 2007 22:48:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 15/19] kbuild: warn about references from .init.text to .exit.text
Message-ID: <20070603204848.GP9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 15/19] kbuild: warn about references from .init.text to .exit.text
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 2 Jun 2007 21:29:20 +0200

The .exit.text section may be discarded either at build or at runtime.
So let modpost warn if this situation is detected.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2b881c2..0f9130f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1216,7 +1216,6 @@ static int exit_section_ref_ok(const char *name)
 		".exit.data",
 		".exit.text",
 		".exitcall.exit",
-		".init.text",
 		".rodata",
 		NULL
 	};
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
