Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZDPKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZDPKF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZDPKEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:04:49 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:57955 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbZDPKEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:04:47 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 06/11] microblaze: Remove sparse error in traps.c
Date: Thu, 16 Apr 2009 11:56:33 +0200
Message-Id: <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

CHECK   arch/microblaze/kernel/traps.c
arch/microblaze/kernel/traps.c:37:47: warning: Using plain integer as NULL pointer
CC      arch/microblaze/kernel/traps.o

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index fbdc533..293ef48 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -34,7 +34,7 @@ static int kstack_depth_to_print = 24;
 
 static int __init kstack_setup(char *s)
 {
-	kstack_depth_to_print = strict_strtoul(s, 0, 0);
+	kstack_depth_to_print = strict_strtoul(s, 0, NULL);
 
 	return 1;
 }
-- 
1.5.5.1

