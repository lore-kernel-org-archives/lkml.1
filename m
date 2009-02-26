Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZBZOCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZBZOCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZBZOB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:01:56 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:32069 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZBZOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k7hSRJn/Wbh/fh0N43nBrwSzzQ2rztw3Kes+UI9YzCSsHRfbzMVcG2HH0ASlJugQEB
         79HcyiYpz4c5sfzwD6HhbBG21Ri8MFAWIK3CAqEW0qCipetowrsQN53ek53W7BVpF+MI
         +jR9ilUpg8/OxPLm76smfEK5RlIn52of3BpY0=
Date: Thu, 26 Feb 2009 15:01:47 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck updates for -tip
Message-ID: <20090226140147.GA2824@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following changes since commit 8f5bd505f147bcd57c627e8599cbcc6b082312d4:
  Ingo Molnar (1):
        Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Pekka Enberg (7):
      kmemcheck: Disable SLUB and SLAB debugging when kmemcheck is enabled
      kmemcheck: remove forward declarations from error.c
      kmemcheck: make initialization message less confusing
      kmemcheck: remove multiple ifdef'd definitions of the same global variable
      kmemcheck: move 64-bit ifdef out of kmemcheck_opcode_decode()
      kmemcheck: missing whitespace in do_page_fault()
      kmemcheck: use kmemcheck_pte_lookup() instead of open-coding it

Vegard Nossum (9):
      kmemcheck: fix an incorrect BUG_ON()
      kmemcheck: fix shadow updates that cross page boundaries
      crypto: don't track xor test pages with kmemcheck
      x86: don't use MMX/SSE in xor routines if kmemcheck is compiled in
      kmemcheck: reverse dependencies between DEBUG_PAGEALLOC and KMEMCHECK
      kmemcheck: depend on DEBUG_KERNEL
      c2port: annotate bitfield for kmemcheck
      kmemcheck (bitfields): don't actually initialize the bitfield
      net: annotate struct sock bitfield

 arch/x86/Kconfig.debug            |    6 +-
 arch/x86/include/asm/xor.h        |    5 ++
 arch/x86/mm/fault.c               |    2 +-
 arch/x86/mm/kmemcheck/error.c     |  137 ++++++++++++++++++-------------------
 arch/x86/mm/kmemcheck/kmemcheck.c |   20 ++---
 arch/x86/mm/kmemcheck/opcode.c    |    9 ++-
 arch/x86/mm/kmemcheck/shadow.c    |   38 +++++++++-
 crypto/xor.c                      |    7 ++-
 drivers/misc/c2port/core.c        |    2 +
 include/linux/c2port.h            |    7 ++-
 include/linux/kmemcheck.h         |    6 +-
 include/net/sock.h                |    8 ++-
 lib/Kconfig.debug                 |    4 +-
 net/core/sock.c                   |    2 +
 14 files changed, 151 insertions(+), 102 deletions(-)


Vegard
