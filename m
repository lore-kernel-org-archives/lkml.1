Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZCJQuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZCJQuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZCJQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:57 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34615 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <69d532ce2b65d0cd6ff1cf018fb8c84c448b334f.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:25:04 +0000
Subject: [PATCH 17/31] toshiba: Auto-load toshiba module when device opened.
To: linux-kernel@vger.kernel.org
Cc: jonathan@buzzard.org.uk, tlinux-users@tce.toshiba-dme.co.jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The toshiba module is missing the char-major-10-181 alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/toshiba.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 663cd15..7212f5f 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -77,6 +77,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jonathan Buzzard <jonathan@buzzard.org.uk>");
 MODULE_DESCRIPTION("Toshiba laptop SMM driver");
 MODULE_SUPPORTED_DEVICE("toshiba");
+MODULE_ALIAS_MISCDEV(TOSH_MINOR_DEV);
 
 static int tosh_fn;
 module_param_named(fn, tosh_fn, int, 0);
-- 
1.6.0.5

