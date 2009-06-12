Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbZFLQcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbZFLQcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763031AbZFLQZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764536AbZFLQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 23/27] Blackfin: enable support for LOCKDEP
Date: Fri, 12 Jun 2009 12:24:41 -0400
Message-Id: <1244823885-22410-24-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 77ec14f..d03fd63 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -55,6 +55,9 @@ config FORCE_MAX_ZONEORDER
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config LOCKDEP_SUPPORT
+	def_bool y
+
 config STACKTRACE_SUPPORT
 	def_bool y
 
-- 
1.6.3.1

