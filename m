Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbYD3RxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbYD3RxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYD3Rwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:52:49 -0400
Received: from saeurebad.de ([85.214.36.134]:60172 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763632AbYD3Rws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:52:48 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Wed Apr 30 19:08:39 2008
Message-Id: <20080430170521.246745395@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 30 Apr 2008 19:05:21 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/4] Bootmem cleanups
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I now dropped the node-crossing patches from my bootmem series and
here is what is left over.

They apply to Linus' current git
(0ff5ce7f30b45cc2014cec465c0e96c16877116e).

Please note that all parts affecting !X86_32_BORING_UMA_BOX are untested!

 arch/alpha/mm/numa.c             |    8 ++--
 arch/arm/mm/discontig.c          |   34 ++++++++++-----------
 arch/ia64/mm/discontig.c         |   11 +++----
 arch/m32r/mm/discontig.c         |    4 +--
 arch/m68k/mm/init.c              |    4 +--
 arch/mips/sgi-ip27/ip27-memory.c |    3 +-
 arch/parisc/mm/init.c            |    3 +-
 arch/powerpc/mm/numa.c           |    3 +-
 arch/sh/mm/numa.c                |    5 +--
 arch/sparc64/mm/init.c           |    3 +-
 arch/x86/mm/discontig_32.c       |    3 +-
 arch/x86/mm/numa_64.c            |    6 +---
 include/linux/bootmem.h          |    7 +---
 mm/bootmem.c                     |   59 ++++++++++++++++++-------------------
 mm/page_alloc.c                  |    4 +--
 15 files changed, 67 insertions(+), 90 deletions(-)

	Hannes
