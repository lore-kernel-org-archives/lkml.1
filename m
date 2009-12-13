Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZLMX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZLMX5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZLMX5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34502 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbZLMX5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:14 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, torvalds@linux-foundation.org,
       len.brown@intel.com, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org
Subject: [PATCH 2/3] Constify struct acpi_dock_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:00 +0100
Message-Id: <f0a74efafd3a426b7c58d688f17235271993feca.1260662994.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 8e952fd..bdef77f 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -109,7 +109,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 }
 
 
-static struct acpi_dock_ops acpiphp_dock_ops = {
+static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.handler = handle_hotplug_event_func,
 };
 
-- 
1.6.5.3

