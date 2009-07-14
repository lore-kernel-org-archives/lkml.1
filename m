Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZGNRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZGNRjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZGNRju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:39:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42717 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZGNRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:39:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] libata: pata_bf54x: handle portmuxing of pins through GPIO PORTs
Date: Tue, 14 Jul 2009 13:39:47 -0400
Message-Id: <1247593187-26570-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

By default, the PATA pins are routed to the async address lines in which
case, no peripheral muxing needs to be done.  However, if the pins get
routed through the GPIO PORTs pins, we need to make sure to request them
so that the muxing is properly set up.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: could you pick this up ?  it was posted over a month ago to the
Linux/IDE list w/no feedback.

 drivers/ata/pata_bf54x.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index c4b47a3..02c81f1 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1557,6 +1557,25 @@ static unsigned short atapi_io_port[] = {
 	P_ATAPI_DMARQ,
 	P_ATAPI_INTRQ,
 	P_ATAPI_IORDY,
+	P_ATAPI_D0A,
+	P_ATAPI_D1A,
+	P_ATAPI_D2A,
+	P_ATAPI_D3A,
+	P_ATAPI_D4A,
+	P_ATAPI_D5A,
+	P_ATAPI_D6A,
+	P_ATAPI_D7A,
+	P_ATAPI_D8A,
+	P_ATAPI_D9A,
+	P_ATAPI_D10A,
+	P_ATAPI_D11A,
+	P_ATAPI_D12A,
+	P_ATAPI_D13A,
+	P_ATAPI_D14A,
+	P_ATAPI_D15A,
+	P_ATAPI_A0A,
+	P_ATAPI_A1A,
+	P_ATAPI_A2A,
 	0
 };
 
-- 
1.6.3.3

