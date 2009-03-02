Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZCJQtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZCJQtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZCJQn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:56 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34619 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <fd9db053766bd9fa3d8ffa35daebc90cf25df6cd.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:39:40 +0000
Subject: [PATCH 20/31] specialix: Auto-load specialix module when device opened.
To: linux-kernel@vger.kernel.org
Cc: R.E.Wolff@BitWizard.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The specialix module is missing the char-major-75-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/specialix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 3c67c3d..e72be41 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2365,3 +2365,4 @@ module_init(specialix_init_module);
 module_exit(specialix_exit_module);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SPECIALIX_NORMAL_MAJOR);
-- 
1.6.0.5

