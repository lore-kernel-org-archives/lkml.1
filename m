Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZCJQtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZCJQtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZCJQny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:54 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34624 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbZCJQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:41 -0400
Message-Id: <20648ad5975623975f64a3d834dad597014f0473.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Thu, 5 Mar 2009 15:31:24 +0000
Subject: [PATCH 30/31] mwave: Auto-load mwave module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mwave module is missing the char-major-10-219 alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alias

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/mwave/mwavedd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 94ad2c3..cf9e383 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -67,6 +67,7 @@
 MODULE_DESCRIPTION("3780i Advanced Communications Processor (Mwave) driver");
 MODULE_AUTHOR("Mike Sullivan and Paul Schroeder");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(MWAVE_MINOR);
 
 /*
 * These parameters support the setting of MWave resources. Note that no
-- 
1.6.0.5

