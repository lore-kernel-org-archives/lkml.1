Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYB2Boe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYB2Boe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYB2Bo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:44:26 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbYB2BoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:44:25 -0500
Date: Thu, 28 Feb 2008 17:43:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-Id: <20080228174349.1da254bd.akpm@linux-foundation.org>
In-Reply-To: <20080229003954.GA525@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
	<20080228071822.GA13571@elte.hu>
	<20080229003954.GA525@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 17:39:54 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Feb 28, 2008 at 08:18:23AM +0100, Ingo Molnar wrote:
> > very nice work!
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> Thanks!
> 
> Stephen, I've put the semaphore patches into a git tree; can you add it
> to linux-next?
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore
> 

err, we'd better tell the arch maintainers than we just deleted all their
sempahore code.

edited list:

 arch/alpha/kernel/semaphore.c                    |  224 --------------------
 arch/arm/kernel/semaphore.c                      |  221 --------------------
 arch/avr32/kernel/semaphore.c                    |  148 -------------
 arch/cris/kernel/semaphore.c                     |  129 -----------
 arch/frv/kernel/semaphore.c                      |  155 --------------
 arch/h8300/kernel/semaphore.c                    |  132 -----------
 arch/ia64/kernel/semaphore.c                     |  165 --------------
 arch/m32r/kernel/semaphore.c                     |  185 ----------------
 arch/m68k/kernel/semaphore.c                     |  132 -----------
 arch/m68k/lib/semaphore.S                        |   53 ----
 arch/m68knommu/kernel/semaphore.c                |  133 ------------
 arch/m68knommu/lib/semaphore.S                   |   66 -----
 arch/mips/kernel/semaphore.c                     |  168 ---------------
 arch/mn10300/kernel/semaphore.c                  |  149 -------------
 arch/parisc/kernel/semaphore.c                   |  102 ---------
 arch/powerpc/kernel/semaphore.c                  |  135 ------------
 arch/ppc/kernel/semaphore.c                      |  131 -----------
 arch/s390/kernel/semaphore.c                     |  108 ---------
 arch/sh/kernel/semaphore.c                       |  139 ------------
 arch/sparc/kernel/semaphore.c                    |  155 --------------
 arch/sparc64/kernel/semaphore.c                  |  254 -----------------------
 arch/v850/kernel/semaphore.c                     |  166 ---------------
 arch/xtensa/kernel/semaphore.c                   |  226 --------------------
 b/arch/x86/lib/semaphore_32.S                    |   83 -------
 b/include/asm-alpha/semaphore.h                  |  150 -------------
 b/include/asm-arm/semaphore.h                    |   99 --------
 b/include/asm-avr32/semaphore.h                  |  109 ---------
 b/include/asm-blackfin/semaphore.h               |  106 ---------
 b/include/asm-cris/semaphore.h                   |  134 ------------
 b/include/asm-frv/semaphore.h                    |  156 --------------
 b/include/asm-h8300/semaphore.h                  |  191 -----------------
 b/include/asm-ia64/semaphore.h                   |  100 ---------
 b/include/asm-m32r/semaphore.h                   |  145 -------------
 b/include/asm-m68k/semaphore.h                   |  164 --------------
 b/include/asm-m68knommu/semaphore.h              |  154 -------------
 b/include/asm-mips/semaphore.h                   |  109 ---------
 b/include/asm-mn10300/semaphore.h                |  170 ---------------
 b/include/asm-parisc/semaphore.h                 |  146 -------------
 b/include/asm-powerpc/semaphore.h                |   95 --------
 b/include/asm-s390/semaphore.h                   |  108 ---------
 b/include/asm-sh/semaphore.h                     |  116 ----------
 b/include/asm-sparc/semaphore.h                  |  193 -----------------
 b/include/asm-sparc64/semaphore.h                |   54 ----
 b/include/asm-v850/semaphore.h                   |   85 -------
 b/include/asm-xtensa/semaphore.h                 |  100 ---------
 b/include/linux/semaphore.h                      |   81 +++++++
 b/kernel/semaphore.c                             |  204 ++++++++++++++++++
 include/asm-arm/semaphore-helper.h               |   84 -------
 include/asm-blackfin/semaphore-helper.h          |   82 -------
 include/asm-cris/semaphore-helper.h              |   78 -------
 include/asm-h8300/semaphore-helper.h             |   85 -------
 include/asm-m68k/semaphore-helper.h              |  142 ------------
 include/asm-m68knommu/semaphore-helper.h         |   82 -------
 include/asm-parisc/semaphore-helper.h            |   89 --------
 include/asm-sh/semaphore-helper.h                |   89 --------
 include/asm-x86/semaphore_32.h                   |  175 ---------------
 include/asm-x86/semaphore_64.h                   |  180 ----------------
 lib/semaphore-sleepers.c                         |  176 ---------------

yummy summary:

 254 files changed, 386 insertions(+), 7827 deletions(-)

The only major conflict is with avr32 which seems to have just done a major
revamp of that architecture's semaphore implementation.  Oh well.

There are a couple of small #include rejects here and there, nothing at all
major.


Yes, let's get this into linux-next if poss please.  If mainline later
breaks for some architecture, well, we did our best..
