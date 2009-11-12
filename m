Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZKLQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZKLQGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZKLQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:06:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54510 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753217AbZKLQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:06:44 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] [CPUFREQ] Document units for transition latency
Date: Thu, 12 Nov 2009 16:06:45 +0000
Message-Id: <1258042005-29453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're documented in the header but not in Documentation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/cpu-freq/cpu-drivers.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 75a58d1..6c30e93 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -92,9 +92,9 @@ policy->cpuinfo.max_freq -	the minimum and maximum frequency
 				(in kHz) which is supported by 
 				this CPU
 policy->cpuinfo.transition_latency   the time it takes on this CPU to
-				switch between two frequencies (if
-				appropriate, else specify
-				CPUFREQ_ETERNAL)
+				switch between two frequencies in
+				nanoseconds (if appropriate, else
+				specify CPUFREQ_ETERNAL)
 
 policy->cur			The current operating frequency of
 				this CPU (if appropriate)
-- 
1.6.5.2

