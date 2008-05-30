Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYE3UCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYE3UCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYE3UCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:02:34 -0400
Received: from saeurebad.de ([85.214.36.134]:60826 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYE3UCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:02:34 -0400
Message-Id: <20080530194220.286976884@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 21:42:20 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mm 00/14] bootmem rewrite v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

to your request I broke up this big diff into more reviewable smaller
chunks.  They apply to -mmotm (modulo the conflicts I ran into, but
they seemed unrelated).

So, here is another version of my attempt to cleanly rewrite the
bootmem allocator.  More details in the respective patch changelogs.

Compile- and runtime tested on x86 32bit UMA.

	Hannes

 arch/alpha/mm/numa.c     |    2 +-
 arch/arm/plat-omap/fb.c  |    4 +-
 arch/avr32/mm/init.c     |    3 +-
 arch/ia64/mm/discontig.c |   19 +-
 arch/m32r/mm/discontig.c |    3 +-
 arch/m32r/mm/init.c      |    4 +-
 arch/mn10300/mm/init.c   |    6 +-
 arch/sh/mm/init.c        |    2 +-
 include/linux/bootmem.h  |   82 ++--
 mm/bootmem.c             |  918 +++++++++++++++++++++++++---------------------
 10 files changed, 552 insertions(+), 491 deletions(-)
