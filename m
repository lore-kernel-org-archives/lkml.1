Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZEOQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZEOQcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762573AbZEOQcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:32:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZEOQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:32:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] x86: use asm-generic headers where possible
Date: Fri, 15 May 2009 18:32:05 +0200
Message-Id: <cover.1242403836.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
X-Provags-ID: V01U2FsdGVkX19FCFXfMZJoaMFQ7Gflc+R2QZu7Cy1JyvbWbpq
 LwVRW1Iv23QorlctgK8ouDaZx6Kpdz/NMFukNf+Z7E7mSof+bZ
 bq0tSaOJTE6wsKaFXn0dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my follow-up for my asm-generic header patches with
x86 specific changes. I've split the series up into five
patches for easier review. Each step should show clearly that
no semantic changes are introduced, with the exception of
termios.h, which was discussed earlier.

I have also checked that the resulting object code is the same,
again with the exception of termios.h, because that fixes
a small bug.

The patches are based on my asm-generic tree at
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
They can also be found in the x86 branch there.

	Arnd <><

Arnd Bergmann (5):
  x86: add copies of some headers to convert to asm-generic
  x86: convert trivial headers to asm-generic version
  x86: convert almost generic headers to asm-generic version
  x86: convert termios.h to the asm-generic version
  x86: remove all now-duplicate header files

 arch/x86/include/asm/ioctls.h      |   95 +-----------------
 arch/x86/include/asm/ipcbuf.h      |   29 +-----
 arch/x86/include/asm/kmap_types.h  |   30 +-----
 arch/x86/include/asm/mman.h        |   28 ++----
 arch/x86/include/asm/module.h      |   13 +--
 arch/x86/include/asm/msgbuf.h      |   40 +-------
 arch/x86/include/asm/param.h       |   23 +----
 arch/x86/include/asm/scatterlist.h |   41 ++------
 arch/x86/include/asm/shmbuf.h      |   52 +---------
 arch/x86/include/asm/socket.h      |   61 +-----------
 arch/x86/include/asm/sockios.h     |   14 +---
 arch/x86/include/asm/termbits.h    |  199 +-----------------------------------
 arch/x86/include/asm/termios.h     |  114 +--------------------
 arch/x86/include/asm/types.h       |   12 +--
 arch/x86/include/asm/ucontext.h    |    8 +--
 15 files changed, 30 insertions(+), 729 deletions(-)
 rewrite arch/x86/include/asm/ioctls.h (100%)
 rewrite arch/x86/include/asm/ipcbuf.h (100%)
 rewrite arch/x86/include/asm/kmap_types.h (100%)
 rewrite arch/x86/include/asm/mman.h (82%)
 rewrite arch/x86/include/asm/msgbuf.h (100%)
 rewrite arch/x86/include/asm/param.h (100%)
 rewrite arch/x86/include/asm/scatterlist.h (82%)
 rewrite arch/x86/include/asm/shmbuf.h (100%)
 rewrite arch/x86/include/asm/socket.h (100%)
 rewrite arch/x86/include/asm/termbits.h (100%)
 rewrite arch/x86/include/asm/termios.h (100%)

