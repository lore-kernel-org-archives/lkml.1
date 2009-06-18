Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZFRR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZFRR5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZFRR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:56:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZFRRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/11] microblaze: remove init_mm
Date: Thu, 18 Jun 2009 19:55:26 +0200
Message-Id: <21337f72787b821e73f1f9a94e1cca42c1026085.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/peoZd6C3LP2fLKBPi5+K3gUy+5lnedmHHlz
 VCDrAOdtUC/dTTu1gKs54hcsXtm40PtvtD+4LRY5gXytIjctE0
 Z7pbO/DG9H2Ld060Bp2Cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey removed the definition for init_mm from all architectures
but forgot microblaze, which was only recently added.
This fixes the microblaze build by dropping it there as well.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/kernel/init_task.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
index 48eb9fb..67da225 100644
--- a/arch/microblaze/kernel/init_task.c
+++ b/arch/microblaze/kernel/init_task.c
@@ -18,8 +18,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
 	__attribute__((__section__(".data.init_task"))) =
-- 
1.6.3.1

