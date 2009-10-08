Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbZJHGFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbZJHGFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbZJHGFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34637 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbZJHGFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 13/13] Blackfin: convert to GENERIC_HARDIRQS_NO__DO_IRQ
Date: Thu,  8 Oct 2009 02:04:29 -0400
Message-Id: <1254981869-21586-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Blackfin already sets proper flow handlers on all IRQs, and we don't rely
on __do_IRQ, therefore we can simply select GENERIC_HARDIRQS_NO__DO_IRQ.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index e519882..ae6a60f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -47,6 +47,9 @@ config GENERIC_HARDIRQS
 config GENERIC_IRQ_PROBE
 	def_bool y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
 config GENERIC_GPIO
 	def_bool y
 
-- 
1.6.5.rc2

