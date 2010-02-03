Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0BCQv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:51:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab0BCQv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:51:27 -0500
Date: Wed, 3 Feb 2010 17:51:20 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] trace-cmd: teach git to ignore dependency files (*.d)
Message-ID: <alpine.LFD.2.00.1002031749320.6302@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fc439caf5a0df5ff735d8f783a29709849c4d83b Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 3 Feb 2010 16:39:15 +0100
Subject: [PATCH] trace-cmd: teach git to ignore dependency files (*.d)

Teach git to ignore dependency files (*.d)

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8e8f5a4..0dcd8cd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,6 +5,7 @@ trace-cmd
 *.dat
 *.patch
 *~
+*.d
 kernelshark
 trace-graph
 trace-view
-- 
1.6.0.6

