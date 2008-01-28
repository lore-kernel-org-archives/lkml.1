Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbYA1WVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbYA1WVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762809AbYA1WO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:14:27 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46657 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762191AbYA1WOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:14:25 -0500
Date: Tue, 29 Jan 2008 00:14:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport touch_all_softlockup_watchdogs
Message-ID: <20080128221452.GL8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(touch_all_softlockup_watchdogs).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
788c6505d48f13a2b6d3f7313599dad12ec869fe 
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c1d7655..6616250 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -65,7 +65,6 @@ void touch_all_softlockup_watchdogs(void)
 	for_each_online_cpu(cpu)
 		per_cpu(touch_timestamp, cpu) = 0;
 }
-EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
 /*
  * This callback runs from the timer interrupt, and checks

