Return-Path: <linux-kernel-owner+w=401wt.eu-S935028AbXHGXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbXHGXo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXHGXoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:44:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbXHGXoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:44:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Use linux/elfcore-compat.h
In-Reply-To: Arnd Bergmann's message of  Wednesday, 8 August 2007 00:08:20 +0200 <200708080008.20738.arnd@arndb.de>
X-Shopping-List: (1) Viscous brunch
   (2) Superstitious confrontations
   (3) Archaic porno retarders
   (4) Illogical lackadaisical omissions
Message-Id: <20070807234343.C762D4D04C4@magilla.localdomain>
Date: Tue,  7 Aug 2007 16:43:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is hardly anything interesting remaining in 
> arch/powerpc/kernel/binfmt_elf32.c after your patch.
> 
> Do you think it's reasonable to go one step further and
> turn the file into a completely generic fs/binfmt_elf32.c
> that can be used by all 32/64 compat architectures?

There is certainly more cleanup that can be done.  
This was just an easy incremental step.

It's not going to get quite to "completely generic".  On other machines the
32/64 flavors are not quite as similar as on powerpc, so there is some more
code required there.  There will have to be a lot of per-arch macros and
functions, even if they are unified to compat_* names.


Thanks,
Roland
