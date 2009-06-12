Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbZFLNBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbZFLNBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbZFLM7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14400
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762281AbZFLM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 8,
X-WSS-ID: 0KL4MQJ-04-6AB-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/23] oprofile: remove obselete include headers
Date: Fri, 12 Jun 2009 14:35:22 +0200
Message-ID: <1244810140-20595-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0795 (UTC) FILETIME=[913D0130:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This became obsolete with this commit:

 6dad828 oprofile: port to the new ring_buffer

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 242257b..50640cc 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -21,7 +21,6 @@
 
 #include <linux/sched.h>
 #include <linux/oprofile.h>
-#include <linux/vmalloc.h>
 #include <linux/errno.h>
 
 #include "event_buffer.h"
-- 
1.6.3.1


