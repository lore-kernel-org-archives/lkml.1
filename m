Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZK1O6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZK1O6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 09:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZK1O6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 09:58:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:35203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751539AbZK1O6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 09:58:12 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX18YQVoZUq0YddVDugs6PIRlTGwstjjj5T7vPBPTrj
	6AHYPdHJz0lff0
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org
Cc: Johannes Buchner <buchner.johannes@gmx.at>
Subject: [PATCH] Documentation: ignore_nice_load is in conservative cpufreq too
Date: Sun, 29 Nov 2009 03:58:42 +1300
Message-Id: <1259420322-24542-1-git-send-email-buchner.johannes@gmx.at>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a feature in the source and sysfs, but not mentioned in the docs.

Signed-off-by: Johannes Buchner <buchner.johannes@gmx.at>
---
 Documentation/cpu-freq/governors.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index aed082f..eb5d584 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -182,6 +182,8 @@ governor but for the opposite direction.  For example when set to its
 default value of '20' it means that if the CPU usage needs to be below
 20% between samples to have the frequency decreased.
 
+ignore_nice_load: same as for the "ondemand" governor.
+
 3. The Governor Interface in the CPUfreq Core
 =============================================
 
-- 
1.6.4.4

