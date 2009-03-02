Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZCJQqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZCJQqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbZCJQnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:47 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34595 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <35200e925d5b88f292386bab8546c810ac7c2113.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:24:16 +0000
Subject: [PATCH 16/31] applicom: Auto-load applicom module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The applicom module is missing the char-major-10-157 alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/applicom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 05674fe..73a0765 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -75,6 +75,7 @@ MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
 MODULE_AUTHOR("David Woodhouse & Applicom International");
 MODULE_DESCRIPTION("Driver for Applicom Profibus card");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(AC_MINOR);
 
 MODULE_SUPPORTED_DEVICE("ac");
 
-- 
1.6.0.5

