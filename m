Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZCJQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZCJQqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZCJQnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:46 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34593 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <e94848a44db70e3b556c2107bc2cf0a37fd2ea7c.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:20:38 +0000
Subject: [PATCH 14/31] hw_random: Auto-load rng-core module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rng-core module is missing the char-major-10-183 alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/hw_random/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e5d583c..fd7dff2 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -347,3 +347,4 @@ EXPORT_SYMBOL_GPL(hwrng_unregister);
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(RNG_MISCDEV_MINOR);
-- 
1.6.0.5

