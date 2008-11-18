Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYKRHB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYKRHB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYKRHA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:00:57 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:6515 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYKRHA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:00:56 -0500
X-IronPort-AV: E=Sophos;i="4.33,623,1220241600"; 
   d="scan'208";a="62688307"
From: Bryan Wu <cooloney@kernel.org>
To: linux@dominikbrodowski.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] pcmcia: Blackfin: fix bug - add missing ; to MODULE macro
Date: Tue, 18 Nov 2008 15:02:13 +0800
Message-Id: <1226991733-30506-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index bb73388..b59d411 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -334,6 +334,6 @@ static void __exit bfin_cf_exit(void)
 module_init(bfin_cf_init);
 module_exit(bfin_cf_exit);
 
-MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>")
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("BFIN CF/PCMCIA Driver");
 MODULE_LICENSE("GPL");
-- 
1.5.6.3
