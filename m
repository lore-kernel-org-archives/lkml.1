Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLIVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLIVlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYLIVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:41:11 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41293 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYLIVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OoyGbt1ROEuJng0Zpu0eraZPP3YZGNoD/YkcKzCWneXikGnN8iACItekHISSy+3JZQ
         D8VE91FAP37UA7xBXghKRbxByOA5hhyn6wTt0BgYdba++9FLETMga1kA4m7Ifdh0Y2ty
         zDF2fMlzWSQw6GOpqmV/i5VsnqL3J5upNOZoI=
Message-ID: <493EE5F3.8090002@gmail.com>
Date: Tue, 09 Dec 2008 22:41:07 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: astarikovskiy@suse.de
CC: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/31] drivers/power: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/power/olpc_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 5fbca26..a9fd570 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -379,7 +379,7 @@ static struct power_supply olpc_bat = {
 	.use_for_apm = 1,
 };
 
-void olpc_battery_trigger_uevent(unsigned long cause)
+static void olpc_battery_trigger_uevent(unsigned long cause)
 {
 	if (cause & EC_SCI_SRC_ACPWR)
 		kobject_uevent(&olpc_ac.dev->kobj, KOBJ_CHANGE);

