Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGAX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGAX2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZGAX2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:28:31 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:47282 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZGAX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:28:30 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] Include linux/errno.h in linux/sysrq.h
Date: Thu,  2 Jul 2009 01:28:26 +0200
Message-Id: <1246490906-16024-1-git-send-email-tobias.doerffel@gmail.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: e3260060fbba42ba6f18958e4f5000eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/sysrq.h the constant EINVAL is being used but is undefined
if include/linux/errno.h is not included before.

Fix this by adding #include <linux/errno.h> at the beginning.

Signed-off-by: Tobias Doerffel <tobias.doerffel@gmail.com>
---
 include/linux/sysrq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 98a1d8c..99adcdc 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -14,6 +14,8 @@
 #ifndef _LINUX_SYSRQ_H
 #define _LINUX_SYSRQ_H
 
+#include <linux/errno.h>
+
 struct pt_regs;
 struct tty_struct;
 
-- 
1.6.3.3

