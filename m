Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZCFGm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZCFGm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZCFGk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:40:59 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50912 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZCFGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:56 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883653"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 09/18] Blackfin Serial Driver: irq funcs take an unsigned long for flags
Date: Fri,  6 Mar 2009 14:42:51 +0800
Message-Id: <1236321780-28718-10-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 2eab47e..130e321 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1251,7 +1251,8 @@ void bfin_serial_debug(const char *fmt, ...)
 {
 	struct bfin_serial_port *uart = &bfin_serial_ports[0];
 	unsigned short status, tmp;
-	int flags, i, count;
+	unsigned long flags;
+	int i, count;
 	char buf[128];
 	va_list ap;
 
-- 
1.5.6.3
