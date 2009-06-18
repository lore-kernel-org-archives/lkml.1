Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZFRTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZFRTtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZFRTtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:49:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbZFRTtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:49:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5, resend] x86: use asm-generic headers where possible
Date: Thu, 18 Jun 2009 21:48:15 +0200
Message-Id: <cover.1245354003.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
X-Provags-ID: V01U2FsdGVkX18PrO34C4GvRytijuak8JAAguJKOzUdsrx6yk/
 SClr7oydhjsMJTgJMG3s/sdVn5EM/DF5D+ey6i54qhjTxus0us
 X4yUT08aOsgEcjpMLebhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not get any feedback on this the last time I sent it,
but now these patches actually apply to the mainline kernel
so it's possible to apply them.

I've split the series up into five patches for easier review.
Each step should show clearly that no semantic changes are
introduced, with the exception of termios.h, which was
discussed earlier.

I have also checked that the resulting object code is the same,
again with the exception of termios.h, because that fixes
a small bug.

Arnd Bergmann (5):
  x86: add copies of some headers to convert to asm-generic
  x86: convert trivial headers to asm-generic version
  x86: convert almost generic headers to asm-generic version
  x86: convert termios.h to the asm-generic version
  x86: remove all now-duplicate header files

 arch/x86/include/asm/ioctls.h      |   95 +-----------------
 arch/x86/include/asm/ipcbuf.h      |   29 +-----
 arch/x86/include/asm/mman.h        |   28 ++----
 arch/x86/include/asm/module.h      |   13 +--
 arch/x86/include/asm/msgbuf.h      |   40 +-------
 arch/x86/include/asm/param.h       |   23 +----
 arch/x86/include/asm/scatterlist.h |   41 ++------
 arch/x86/include/asm/shmbuf.h      |   52 +---------
 arch/x86/include/asm/socket.h      |   61 +-----------
 arch/x86/include/asm/sockios.h     |   14 +---
 arch/x86/include/asm/termbits.h    |  199 +-----------------------------------
 arch/x86/include/asm/termios.h     |  115 +--------------------
 arch/x86/include/asm/types.h       |   12 +--
 arch/x86/include/asm/ucontext.h    |    8 +--
 14 files changed, 29 insertions(+), 701 deletions(-)
 rewrite arch/x86/include/asm/ioctls.h (100%)
 rewrite arch/x86/include/asm/ipcbuf.h (100%)
 rewrite arch/x86/include/asm/mman.h (82%)
 rewrite arch/x86/include/asm/msgbuf.h (100%)
 rewrite arch/x86/include/asm/param.h (100%)
 rewrite arch/x86/include/asm/scatterlist.h (82%)
 rewrite arch/x86/include/asm/shmbuf.h (100%)
 rewrite arch/x86/include/asm/socket.h (100%)
 rewrite arch/x86/include/asm/termbits.h (100%)
 rewrite arch/x86/include/asm/termios.h (100%)

