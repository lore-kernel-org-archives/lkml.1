Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZCVQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZCVQd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZCVQdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:33:46 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:49939 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZCVQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:33:45 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/2] One variable in kernel/time/tick-broadcast.c can become static
Date: Sun, 22 Mar 2009 18:33:31 +0200
Message-Id: <1237739612-18507-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable tick_broadcast_device is not used outside of the
file where it is defined, so let's make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 kernel/time/tick-broadcast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 118a3b3..877dbed 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -27,7 +27,7 @@
  * timer stops in C3 state.
  */
 
-struct tick_device tick_broadcast_device;
+static struct tick_device tick_broadcast_device;
 /* FIXME: Use cpumask_var_t. */
 static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
 static DECLARE_BITMAP(tmpmask, NR_CPUS);
-- 
1.5.6.3

