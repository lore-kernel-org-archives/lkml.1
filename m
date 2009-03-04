Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZCDN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZCDN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZCDN5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:57:08 -0500
Received: from mx1.emlix.com ([193.175.82.87]:44632 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbZCDN5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:57:06 -0500
Date: Wed, 4 Mar 2009 14:57:30 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] xtensa: add flat support
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1Lerap-0000Rw-Ul@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

Add the arch-specific header for flat support on xtensa in preparation
for the Xtensa S6000 nommu port.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/flat.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- /dev/null
+++ b/arch/xtensa/include/asm/flat.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_XTENSA_FLAT_H
+#define __ASM_XTENSA_FLAT_H
+
+#define flat_argvp_envp_on_stack()			0
+#define flat_old_ram_flag(flags)			(flags)
+#define flat_reloc_valid(reloc, size)			((reloc) <= (size))
+#define flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
+#define flat_put_addr_at_rp(rp, val, relval	)	put_unaligned(val, rp)
+#define flat_get_relocate_addr(rel)			(rel)
+#define flat_set_persistent(relval, p)			0
+
+#endif /* __ASM_XTENSA_FLAT_H */
