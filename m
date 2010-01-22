Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749Ab0AVVtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0AVVtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664Ab0AVVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:49:11 -0500
Received: from server78.greatnet.de ([83.133.96.102]:48994 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0AVVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:49:09 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 16:49:09 EST
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: jonathan@buzzard.org.uk
Cc: alan@linux.intel.com, tlinux-users@tce.toshiba-dme.co.jp,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 1/4] [DRIVERS]: add Toshiba Portege M100 Fn key port
Date: Fri, 22 Jan 2010 22:41:09 +0100
Message-Id: <1264196472-5387-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the Fn Key port of the Toshiba Portege M100 be known to the driver.
So it's possible to get Fn key combinations from /proc/toshiba
.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/char/toshiba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index f8bc79f..4644ea8 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -21,6 +21,7 @@
  *     0xfc1d: Arthur Liu <armie@slap.mine.nu>
  *     0xfc5a: Jacques L'helgoualc'h <lhh@free.fr>
  *     0xfcd1: Mr. Dave Konrad <konrad@xenia.it>
+ *     0xfcff: Henrik Kretzschmar <henne@nachtwindheim.de>
  *
  * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
  *
@@ -348,7 +349,7 @@ static void tosh_set_fn_port(void)
 	switch (tosh_id) {
 		case 0xfc02: case 0xfc04: case 0xfc09: case 0xfc0a: case 0xfc10:
 		case 0xfc11: case 0xfc13: case 0xfc15: case 0xfc1a: case 0xfc1b:
-		case 0xfc5a:
+	case 0xfc5a: case 0xfcff:
 			tosh_fn = 0x62;
 			break;
 		case 0xfc08: case 0xfc17: case 0xfc1d: case 0xfcd1: case 0xfce0:
-- 
1.6.5

