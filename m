Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbZDBQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbZDBQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbZDBQur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:50:47 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:49843 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbZDBQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:50:46 -0400
From: Jon Masters <jcm@jonmasters.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jon Masters <jcm@redhat.com>, Clark Williams <williams@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Jon Masters <jcm@jonmasters.org>
Subject: [PATCH 2/2] SMI detector: add license to the user smidetect script
Date: Thu,  2 Apr 2009 12:50:05 -0400
Message-Id: <1238691005-25286-3-git-send-email-jcm@jonmasters.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
References: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a GPL v2. license to the smidetect script. That script is entirely
optional and can be used to make it easier to control the SMI detector from
within a python project.

Signed-off-by: Jon Masters <jcm@jonmasters.org>
---
 scripts/smidetect |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/smidetect b/scripts/smidetect
index 81593a1..a3ddcee 100644
--- a/scripts/smidetect
+++ b/scripts/smidetect
@@ -1,4 +1,12 @@
 #!/usr/bin/python
+#
+# A simple (optional) python script for interfacing with the smi_detector.
+# This script can be used to configure the smi_detector module, although
+# you can also simply use the debugfs file interface directly.
+#
+# Copyright (C) 2009 Clark Williams <williams@redhat.com>
+#
+# Licensed under the GNU General Public License, version 2.0.
 
 import sys
 import os
-- 
1.6.0.6

