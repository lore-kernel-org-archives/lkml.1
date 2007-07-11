Return-Path: <linux-kernel-owner+w=401wt.eu-S1765735AbXGKVaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765735AbXGKVaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXGKVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:30:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbXGKVar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:30:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
In-Reply-To: Andrew Morton's message of  Wednesday, 11 July 2007 14:09:11 -0700 <20070711140911.707fcfaa.akpm@linux-foundation.org>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20070711213012.4D4694D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 14:30:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jason's kgdb tree does
> 
> AFLAGS		+= -gdwarf2
> 
> (for all architectures!)  Which is better?

It makes no difference on any platform I care about.  -g says "turn on the
default flavor for the target", while -gdwarf2 turns on DWARF flavor even
if the default is different.  Every target I know anything in particular
about has DWARF as the default flavor anyway.


Thanks,
Roland
