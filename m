Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbXJNVaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbXJNVaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbXJNV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:29:54 -0400
Received: from www.tglx.de ([62.245.132.106]:54657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759798AbXJNV3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:29:53 -0400
Date: Sun, 14 Oct 2007 23:29:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: {GIT pull] x86 bugfixes
Message-ID: <alpine.LFD.0.9999.0710142326451.22612@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

Thanks,

	tglx
--
Dave Jones (1):
      x86: fix missing include for vsyscall

Thomas Gleixner (3):
      clockevents: introduce force broadcast notifier
      x86: move local APIC timer init to the end of start_secondary()
      x86: force timer broadcast on late AMD C1E detection

 arch/x86/kernel/alternative.c |    1 +
 arch/x86/kernel/apic_64.c     |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_64.c  |    7 ++-----
 include/linux/clockchips.h    |    1 +
 kernel/time/tick-broadcast.c  |   29 +++++++++++++++++++++++------
 kernel/time/tick-common.c     |    1 +
 6 files changed, 54 insertions(+), 11 deletions(-)


