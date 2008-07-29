Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYG2AL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYG2AL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYG2ALu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:11:50 -0400
Received: from ozlabs.org ([203.10.76.45]:55144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYG2ALt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:11:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest patches
Date: Tue, 29 Jul 2008 10:11:35 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@saeurebad.de>,
       Mark McLoughlin <markmc@redhat.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291011.36330.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 63add2f2072e69c1eb7a5f6ca8f415122da889b9:
  Linus Torvalds (1):
        Merge branch 'cpus4096-v2' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Andrew Morton (1):
      lguest: use cpu capability accessors

Johannes Weiner (1):
      lguest: fix switcher_page leak on unload

Mark McLoughlin (2):
      lguest: Don't leak /dev/zero fd
      lguest: Support assigning a MAC address

Rusty Russell (12):
      lguest: set max_pfn_mapped, growl loudly at Yinghai Lu
      lguest: Guest int3 fix
      lguest: fix verbose printing of device features.
      lguest: virtio-rng support
      lguest: wrap last_avail accesses.
      lguest: net block unneeded receive queue update notifications
      lguest: Tell Guest net not to notify us on every packet xmit
      lguest: Adaptive timeout
      lguest: Remove 'network: no dma buffer!' warning
      lguest: Use GSO/IFF_VNET_HDR extensions on tun/tap
      lguest: Enlarge virtio rings
      lguest: turn Waker into a thread, not a process

 Documentation/lguest/lguest.c         |  519 ++++++++++++++++++++++++---------
 arch/x86/lguest/boot.c                |    3 +
 drivers/lguest/core.c                 |    1 +
 drivers/lguest/interrupts_and_traps.c |   24 +-
 drivers/lguest/x86/core.c             |    4 +-
 5 files changed, 409 insertions(+), 142 deletions(-)
