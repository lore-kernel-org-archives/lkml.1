Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYJHPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYJHPd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYJHPdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:33:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYJHPdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:33:19 -0400
Date: Wed, 8 Oct 2008 08:33:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: pull request for range-hrtimer updates
Message-ID: <20081008083320.41840108@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a few changes have been put into the range-hrtimer tree; the first three have been on lkml before, 
the last 2 are build fixes reported in the last few days.... please pull.

The following changes since commit a7cda5d3ae218476927ac3fd9756ea617c4ddfb2:
  Ingo Molnar (1):
        Merge branch 'sched/core'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git master

Arjan van de Ven (5):
      hrtimer: make the nanosleep() syscall use the per process slack
      hrtimer: make the futex() system call use the per process slack value
      hrtimer: peek at the timer queue just before going idle
      select: fix alpha OSF wrapper
      rangetimer: fix x86 build failure for the !HRTIMERS case

 arch/alpha/kernel/osf_sys.c |   13 +++++++------
 drivers/cpuidle/cpuidle.c   |    7 +++++++
 include/linux/hrtimer.h     |    7 +++++++
 kernel/futex.c              |    6 +++++-
 kernel/hrtimer.c            |   37 ++++++++++++++++++++++++++++++++++++-
 5 files changed, 62 insertions(+), 8 deletions(-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
