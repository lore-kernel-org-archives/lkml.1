Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZA1N7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZA1N7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZA1N5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZA1N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:29 -0500
Message-Id: <20090128135457.699163581@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:53:56 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/21] lockdep: lockdep_states.h
Content-Disposition: inline; filename=lockdep-generate4.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a header file to generate all the states from.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_states.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/lockdep_states.h
===================================================================
--- /dev/null
+++ linux-2.6/kernel/lockdep_states.h
@@ -0,0 +1,3 @@
+LOCKDEP_STATE(HARDIRQ)
+LOCKDEP_STATE(SOFTIRQ)
+LOCKDEP_STATE(RECLAIM_FS)

-- 

