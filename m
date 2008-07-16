Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYGPAXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYGPAXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYGPAXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:23:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549AbYGPAXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=kM9D4HcHN95aZ48Pb38RMxK1G4mSgh737kd2Ebl0BP2/nUDXcNUAik3Rk/8iwyj20q
         xO8fp3eZxnIWoJ1Dv8UuTbXr7gBnM/KrMQ7yEQdqjC5sKtEvIVfPEOzPRV3k0Axx53Mt
         8s1sROqN4lYXBXFhYIU2blU5g5EC41lgSBxyE=
Date: Wed, 16 Jul 2008 02:22:46 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] stacktrace: add forward-declaration struct
	task_struct
Message-ID: <20080716002246.GD12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2c5f51b8bdaa509a71a479d6a11053c1db2cdd7b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 13 Jun 2008 15:31:11 +0200
Subject: [PATCH 03/13] stacktrace: add forward-declaration struct task_struct

This is needed if the header is to be free-standing.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/stacktrace.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 2a3cbe8..519ad2d 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -2,6 +2,8 @@
 #define __LINUX_STACKTRACE_H
 
 #ifdef CONFIG_STACKTRACE
+struct task_struct;
+
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
-- 
1.5.5.1

