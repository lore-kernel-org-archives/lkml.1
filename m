Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZBGAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZBGAbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBGAbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:31:32 -0500
Received: from gw.goop.org ([64.81.55.164]:55366 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBGAbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:31:32 -0500
Message-ID: <498CD661.4070804@goop.org>
Date: Fri, 06 Feb 2009 16:31:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] x86: unify some of kernel/irq*.c
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes factor out the differences between 32 and 64-bit do_IRQ 
and unify the rest. Unfortunately there are still quite a few other 
differences (like interrupt stack handling) which preclude further easy 
unification.

Thanks,
    J

The following changes since commit f21daa4d04885a34d1972afa9f82a8aebb6152bb:
  Ingo Molnar (1):
        Merge branch 'out-of-tree'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/x86/unify-irq

Jeremy Fitzhardinge (2):
      x86: add handle_irq() to allow interrupt injection
      x86: unify do_IRQ()

 arch/x86/include/asm/irq.h |    4 +++-
 arch/x86/kernel/irq.c      |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irq_32.c   |   29 +++++------------------------
 arch/x86/kernel/irq_64.c   |   34 +++++-----------------------------
 4 files changed, 51 insertions(+), 54 deletions(-)


