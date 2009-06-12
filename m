Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZFLNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZFLNqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbZFLNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:40:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:42287 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbZFLNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:40:38 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v2 3/8] x86: Remove .dynbss from the vDSO linker script
Date: Fri, 12 Jun 2009 15:40:35 +0200
Message-Id: <1244814040-5810-4-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see, the .dynbss section does not make any sense
and cannot even appear in a shared library.

Remove it.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index af3fa61..c7fa74c 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -53,7 +53,6 @@ SECTIONS
 		*(.got.plt) *(.got)
 		*(.gnu.linkonce.d.*)
 		*(.bss*)
-		*(.dynbss*)
 		*(.gnu.linkonce.b.*)
 	}
 
-- 
1.6.0.2

