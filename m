Return-Path: <linux-kernel-owner+w=401wt.eu-S933719AbXGQOOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbXGQOOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbXGQOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35939 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 31/33] cris: use DATA_DATA in cris
Date: Tue, 17 Jul 2007 16:09:00 +0200
Message-Id: <11846813451659-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813453096-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <11846813442541-git-send-email-sam@ravnborg.org> <11846813443988-git-send-email-sam@ravnborg.org> <1184681345321-git-send-email-sam@ravnborg.org> <11846813451376-git-send-email-sam@ravnborg.org> <11846813453096-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

* Sam Ravnborg (sam@ravnborg.org) wrote:
> From your patch it looks like I originally missed out
> powerpc + xtensa when introducing DATA_DATA - would be nice if
> you could fix that.
>

Use DATA_DATA in CRIS

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/cris/arch-v10/vmlinux.lds.S |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
index 4b348b3..9859d49 100644
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ b/arch/cris/arch-v10/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
diff --git a/arch/cris/arch-v32/vmlinux.lds.S b/arch/cris/arch-v32/vmlinux.lds.S
index dfa25e1..e3a32ac 100644
--- a/arch/cris/arch-v32/vmlinux.lds.S
+++ b/arch/cris/arch-v32/vmlinux.lds.S
@@ -49,7 +49,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
-- 
1.5.0.6

