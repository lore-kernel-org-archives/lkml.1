Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbZBITiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbZBITiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZBITgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:36:01 -0500
Received: from gw.goop.org ([64.81.55.164]:56994 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbZBITfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:47 -0500
Message-ID: <49908591.5020406@goop.org>
Date: Mon, 09 Feb 2009 11:35:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] some core Xen updates
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's some core Xen changes: bug fixes, debuggability improvements and cleanups.
These are based on tip/x86/xen, but I've merged in tip/master to bring it up to date
before adding my changes.

BTW, I killed off all the jsgf/* branches in xen.git, but I think you've either
already picked up all the push requests, or I'll resend anything missing.

Thanks,
	J

The following changes since commit a1c51abb06bf03bef6ff973e43cf20a0fa48384f:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/core

Ian Campbell (2):
      Fix xen_flush_tlb_others
      xen: record and display initiator of each multicall when debugging

Jeremy Fitzhardinge (5):
      Merge remote branch 'tip/master' into tip/fixups
      xen: short-circuit tests for dom0
      xen: degrade BUG to WARN when multicall fails
      xen: do multicall callbacks with interrupts disabled
      Merge branch 'tip/fixups' into xen/core

 arch/x86/include/asm/xen/hypervisor.h |   28 ++++++++++++++++++----------
 arch/x86/xen/mmu.c                    |    3 ---
 arch/x86/xen/multicalls.c             |   15 ++++++++++-----
 3 files changed, 28 insertions(+), 18 deletions(-)


