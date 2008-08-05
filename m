Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbYHERRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbYHERRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbYHERRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:17:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37700 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbYHERRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:17:02 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080805717.971524000@firstfloor.org>
In-Reply-To: <20080805717.971524000@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/4] MCE: Add old machine check code to feature-removal-schedule.txt
Message-Id: <20080805171736.6CFC21B90084@one.firstfloor.org>
Date: Tue,  5 Aug 2008 19:17:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt
+++ linux/Documentation/feature-removal-schedule.txt
@@ -321,3 +321,13 @@ Why:	This option was introduced just to
 	to keep working over the upgrade to 2.6.26. At the scheduled time of
 	removal fixed lm-sensors (2.x or 3.x) should be readily available.
 Who:	Rene Herman <rene.herman@gmail.com>
+
+----------------------------
+
+What:   CONFIG_X86_OLD_MCE
+When:	2.6.29
+Why:	Remove the old legacy 32bit machine check code. This has been superseded
+	by the 64bit machine check code, but the old version has been kept
+	around for easier testing. Note this doesn't impact the old P5 and WinChip
+	machine check handlers.
+Who:	Andi Kleen <ak@linux.intel.com>
