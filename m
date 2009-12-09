Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZLIL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZLIL4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZLIL4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:56:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43210 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZLIL4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:56:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cpu-freq: fix default value for ondemand governor
Date: Wed,  9 Dec 2009 06:56:40 -0500
Message-Id: <1260359800-15831-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/cpu-freq/governors.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index aed082f..737988f 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -145,8 +145,8 @@ show_sampling_rate_max: THIS INTERFACE IS DEPRECATED, DON'T USE IT.
 up_threshold: defines what the average CPU usage between the samplings
 of 'sampling_rate' needs to be for the kernel to make a decision on
 whether it should increase the frequency.  For example when it is set
-to its default value of '80' it means that between the checking
-intervals the CPU needs to be on average more than 80% in use to then
+to its default value of '95' it means that between the checking
+intervals the CPU needs to be on average more than 95% in use to then
 decide that the CPU frequency needs to be increased.  
 
 ignore_nice_load: this parameter takes a value of '0' or '1'. When
-- 
1.6.5.5

