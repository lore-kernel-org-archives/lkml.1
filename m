Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZJ3ToI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZJ3ToI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZJ3ToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:44:07 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:55076
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbZJ3ToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:44:05 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: benh@kernel.crashing.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH resend] misc: remove MAC pmu function declaration from misc device class
Date: Fri, 30 Oct 2009 17:43:35 -0200
Message-Id: <1256931816-5802-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c8709334cec803368a432a33e0f2e116d48fe07 has removed the
pmu_device_init call from misc_init, but unlike other similar commits,
has not removed its declaration.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/misc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 07fa612..afc8e26 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -63,8 +63,6 @@ static DEFINE_MUTEX(misc_mtx);
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static unsigned char misc_minors[DYNAMIC_MINORS / 8];
 
-extern int pmu_device_init(void);
-
 #ifdef CONFIG_PROC_FS
 static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
 {
-- 
1.6.3.3

