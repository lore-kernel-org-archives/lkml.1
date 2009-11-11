Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZKKOZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZKKOZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZKKOZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:25:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43826 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZKKOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:25:12 -0500
Subject: [PATCH] regulator: consumer.h - fix build when consumer.h is
 #included first.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 14:25:11 +0000
Message-ID: <1257949511.3089.118.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


consumer.h requires device.h for stand alone build.

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 include/linux/regulator/consumer.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 490c5b3..030d922 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -35,6 +35,8 @@
 #ifndef __LINUX_REGULATOR_CONSUMER_H_
 #define __LINUX_REGULATOR_CONSUMER_H_
 
+#include <linux/device.h>
+
 /*
  * Regulator operating modes.
  *
-- 
1.6.3.3


