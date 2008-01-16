Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYAPJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYAPJ2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYAPJ2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:28:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47849 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAPJ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:28:37 -0500
Subject: [GIT PULL] lockdep updates
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 10:28:31 +0100
Message-Id: <1200475711.7161.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a few lockdep patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-rc7-lockdep

These patches have had a fair amount of testing.

---
Johannes Berg (1):
      lockdep: fix workqueue creation API lockdep interaction

Nick Piggin (1):
      lockdep: fix internal double unlock during self-test

Peter Zijlstra (1):
      lockdep: more hardirq annotations for notify_die()

 arch/x86/kernel/traps_32.c |    1 +
 arch/x86/kernel/traps_64.c |    1 +
 include/linux/workqueue.h  |   14 +++++++++++---
 kernel/lockdep.c           |   12 ++++++++----
 kernel/workqueue.c         |    5 +++--
 5 files changed, 24 insertions(+), 9 deletions(-)


