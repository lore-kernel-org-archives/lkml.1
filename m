Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZLWNKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZLWNKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZLWNKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:10:18 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:61272 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbZLWNKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:10:16 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 08:10:16 EST
From: Tobias Klauser <tklauser@distanz.ch>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] xtensa: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 14:03:01 +0100
Message-Id: <1261573381-8853-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.8.383112, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2009.12.23.125120
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/xtensa/variants/s6000/include/variant/dmac.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/variants/s6000/include/variant/dmac.h b/arch/xtensa/variants/s6000/include/variant/dmac.h
index 89ab948..e81735b 100644
--- a/arch/xtensa/variants/s6000/include/variant/dmac.h
+++ b/arch/xtensa/variants/s6000/include/variant/dmac.h
@@ -357,7 +357,7 @@ static inline u32 s6dmac_channel_enabled(u32 dmac, int chan)
 static inline void s6dmac_dp_setup_group(u32 dmac, int port,
 			int nrch, int frrep)
 {
-	const static u8 mask[4] = {0, 3, 1, 2};
+	static const u8 mask[4] = {0, 3, 1, 2};
 	BUG_ON(dmac != S6_REG_DPDMA);
 	if ((port < 0) || (port > 3) || (nrch < 1) || (nrch > 4))
 		return;
-- 
1.6.3.3

