Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYKDMre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYKDMre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYKDMrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:47:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYKDMrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:47:15 -0500
Subject: [PATCH] x86: remove noirqbalance param docs
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 12:46:03 +0000
Message-Id: <1225802763.6532.34.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqbalance was removed by:

  commit 8b8e8c1bf7275eca859fe551dfa484134eaf013b
  Author: Yinghai Lu <yhlu.kernel@gmail.com>
  Date:   Tue Aug 19 20:50:23 2008 -0700

Remove the associated documentation for noirqbalance.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 Documentation/kernel-parameters.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1bbcaa8..de4de3e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1470,8 +1470,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Valid arguments: on, off
 			Default: on
 
-	noirqbalance	[X86-32,SMP,KNL] Disable kernel irq balancing
-
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
-- 
1.5.4.3

