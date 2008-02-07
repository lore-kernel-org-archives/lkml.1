Return-Path: <linux-kernel-owner+w=401wt.eu-S935423AbYBGVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423AbYBGVWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbYBGVOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:14:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763327AbYBGVOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:14:12 -0500
Date: Thu, 7 Feb 2008 16:13:49 -0500
From: Jason Baron <jbaron@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch 4/4] make pr_debug() dynamic - update docs
Message-ID: <20080207211349.GF14732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-add documentation about pr_debug kernel-parameters.txt

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 Documentation/kernel-parameters.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cf38689..6d524bb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1494,6 +1494,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	pr_debug
+			Enables pr_debug() calls if the immediate
+			infrastructure has been enabled. These can also be
+			switched on/off via /proc/sys/debug/pr_debug.
+
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
