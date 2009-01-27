Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbZA0NxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbZA0NxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZA0Nwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:52:53 -0500
Received: from mail.openmoko.org ([88.198.124.205]:46344 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZA0Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:52:53 -0500
Subject: [PATCH 1/3] pcf50633_charger: Fix typo
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: Anton Vorontsov <cbou@mail.ru>, Andy Green <andy@openmoko.com>
Date: Tue, 27 Jan 2009 19:22:38 +0530
Message-ID: <20090127135238.6875.26314.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.328.gd3b3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/pcf50633-charger.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index e988ec1..41aec2a 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -199,7 +199,8 @@ static int adapter_get_property(struct power_supply *psy,
 			enum power_supply_property psp,
 			union power_supply_propval *val)
 {
-	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
+	struct pcf50633_mbc *mbc = container_of(psy,
+				struct pcf50633_mbc, adapter);
 	int ret = 0;
 
 	switch (psp) {

