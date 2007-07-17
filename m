Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXGQOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXGQOPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760822AbXGQOIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35930 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761352AbXGQOHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:53 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 33/33] xtensa: use DATA_DATA in xtensa
Date: Tue, 17 Jul 2007 16:09:02 +0200
Message-Id: <1184681345776-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681345197-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <11846813442541-git-send-email-sam@ravnborg.org> <11846813443988-git-send-email-sam@ravnborg.org> <1184681345321-git-send-email-sam@ravnborg.org> <11846813451376-git-send-email-sam@ravnborg.org> <11846813453096-git-send-email-sam@ravnborg.org> <11846813451659-git-send-email-sam@ravnborg.org> <1184681345197-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

* Sam Ravnborg (sam@ravnborg.org) wrote:
> From your patch it looks like I originally missed out
> powerpc + xtensa when introducing DATA_DATA - would be nice if
> you could fix that.
>
> 	Sam

Use DATA_DATA in xtensa

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index b0582c3..bb3f1f3 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -118,7 +118,8 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
-- 
1.5.0.6

