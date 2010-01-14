Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495Ab0ANCSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0ANCSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792Ab0ANCSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:18:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0ANCSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:18:17 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] firmware_class: remove base.h header inclusion
Date: Wed, 13 Jan 2010 21:18:15 -0500
Message-Id: <1263435495-10966-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

base.h is used by base drivers for sharing internal structures.
Turns out firmware_class does not depend on it at all so remove it.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Spotted this while backporting firmware_class in compat.git.
Phew, firmware_class can be backported.

 drivers/base/firmware_class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index a950241..8b1cfed 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -19,7 +19,6 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
-#include "base.h"
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
-- 
1.6.3.3

