Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbYGXBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbYGXBFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGXBFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:05:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYGXBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:05:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: Linus Torvalds's message of  Wednesday, 23 July 2008 17:22:55 -0700 <alpine.LFD.1.10.0807231718020.21274@nehalem.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080707065615.77BD9154246@magilla.localdomain>
	<20080707065742.7C119154246@magilla.localdomain>
	<alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
	<20080708000233.E8EF3154244@magilla.localdomain>
	<20080718113615.GD6875@elte.hu>
	<20080721235419.CA3BA1541A5@magilla.localdomain>
	<alpine.LFD.1.10.0807231718020.21274@nehalem.linux-foundation.org>
Emacs: it's all fun and games, until somebody tries to edit a file.
Message-Id: <20080724010435.D642915421D@magilla.localdomain>
Date: Wed, 23 Jul 2008 18:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops!  Duh.  I replaced the same GIT branch with a rebased set that uses
#ifdef CONFIG_AUDITSYSCALL.  No changes to the code you tested, only that
it compiles away to exactly no difference when audit is compiled out.

The following changes since commit 20b7997e8abdf338dcc27fb4f1333c4973a7f113:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/auditsc

Roland McGrath (4):
      x86_64: remove bogus optimization in sysret_signal
      x86_64 syscall audit fast-path
      x86_64 ia32 syscall audit fast-path
      i386 syscall audit fast-path

 arch/x86/ia32/ia32entry.S  |   91 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/entry_32.S |   55 +++++++++++++++++++++++++-
 arch/x86/kernel/entry_64.S |   55 ++++++++++++++++++++++++--
 kernel/auditsc.c           |    3 +-
 4 files changed, 192 insertions(+), 12 deletions(-)


Thanks,
Roland
