Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZLNA3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZLNA3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZLNA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:28:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZLMX5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:21 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jgarzik@pobox.com, tj@kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH 3/3] Constify struct acpi_dock_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:01 +0100
Message-Id: <9285f4ed778df468f8287def65083a4d340c9b88.1260662994.git.re.emese@gmail.com>
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
 drivers/ata/libata-acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 1245838..667111d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -223,12 +223,12 @@ static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
 	ata_acpi_uevent(dev->link->ap, dev, event);
 }
 
-static struct acpi_dock_ops ata_acpi_dev_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
 	.handler = ata_acpi_dev_notify_dock,
 	.uevent = ata_acpi_dev_uevent,
 };
 
-static struct acpi_dock_ops ata_acpi_ap_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.handler = ata_acpi_ap_notify_dock,
 	.uevent = ata_acpi_ap_uevent,
 };
-- 
1.6.5.3

