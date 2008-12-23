Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYLWQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYLWQXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYLWQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:23:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYLWQXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:23:19 -0500
Subject: [PATCH] x86: reboot.c declare port_cf9_safe before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 21:51:28 +0530
Message-Id: <1230049288.14358.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warning

Include "../pci/pci.h" for port_cf9_safe

Fixes this sparse warning:
arch/x86/kernel/reboot.c:43:6: warning: symbol 'port_cf9_safe' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/reboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ba7b9a0..f39e871 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -22,6 +22,7 @@
 #endif
 
 #include <mach_ipi.h>
+#include "../pci/pci.h"
 
 
 /*
-- 
1.5.5.1



