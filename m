Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbZAVRso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbZAVRso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbZAVRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbZAVRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:51 -0500
Message-Id: <20090122174052.381883374@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 04/19] lockdep: lockdep_states.h
Content-Disposition: inline; filename=lockdep-generate4.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a header file to generate all the states from.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c        |    6 +++---
 kernel/lockdep_states.h |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/lockdep_states.h
===================================================================
--- /dev/null
+++ linux-2.6/kernel/lockdep_states.h
@@ -0,0 +1,3 @@
+LOCKDEP_STATE(HARDIRQ)
+LOCKDEP_STATE(SOFTIRQ)
+LOCKDEP_STATE(RECLAIM_FS)

-- 

