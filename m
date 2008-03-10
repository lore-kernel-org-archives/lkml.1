Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYCJUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYCJUSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYCJUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:18:45 -0400
Received: from saeurebad.de ([85.214.36.134]:48316 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYCJUSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:18:44 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Russell King <rmk@arm.linux.org.uk>,
       Lennert Buytenhek <kernel@wantstofly.org>
Subject: Re: [PATCH] arm: Remove redundant display of free swap space in show_mem()
References: <12051798631122-git-send-email-hannes@saeurebad.de>
Date: Mon, 10 Mar 2008 21:16:55 +0100
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de> (Johannes
	Weiner's message of "Mon, 10 Mar 2008 21:10:48 +0100")
Message-ID: <87lk4q72rs.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

apologies to the arm people who got the full thing now.  I obviously
failed the git-send-email test.

-- original introduction

show_mem() has no need to print the amount of free swap space manually
in show_mem(), show_free_areas() does this already.

I have only x86 boxen to test on but the patches are trivial.

 arch/alpha/mm/init.c     |    1 -
 arch/alpha/mm/numa.c     |    1 -
 arch/arm/mm/init.c       |    2 --
 arch/cris/mm/init.c      |    1 -
 arch/ia64/mm/contig.c    |    2 --
 arch/ia64/mm/discontig.c |    2 --
 arch/m32r/mm/init.c      |    2 --
 arch/m68k/mm/init.c      |    1 -
 arch/mips/mm/pgtable.c   |    1 -
 arch/parisc/mm/init.c    |    2 --
 arch/powerpc/mm/mem.c    |    1 -
 arch/ppc/mm/init.c       |    1 -
 arch/s390/mm/init.c      |    1 -
 arch/sh/mm/init.c        |    1 -
 arch/sparc/mm/init.c     |    2 --
 arch/sparc64/mm/init.c   |    2 --
 arch/um/kernel/mem.c     |    2 --
 arch/x86/mm/init_64.c    |    3 ---
 arch/x86/mm/pgtable_32.c |    1 -
 arch/xtensa/mm/init.c    |    1 -
 20 files changed, 0 insertions(+), 30 deletions(-)

	Hannes
