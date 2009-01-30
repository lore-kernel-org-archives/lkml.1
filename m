Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZA3Xki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZA3Xki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZA3Xka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:40:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZA3Xka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:40:30 -0500
Date: Sat, 31 Jan 2009 00:40:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: drop check for CONFIG_ in headers_check
Message-ID: <20090130234012.GF4922@elte.hu>
References: <1233342254.21493.8.camel@localhost.localdomain> <20090130192627.GA32705@elte.hu> <20090130225642.GA17950@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130225642.GA17950@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> The check for references to CONFIG_ symbols in exported headers turned
> out to be too agressive with the current state of affairs.
> After the work of Jaswinder to clean up all relevant cases we are down
> to almost pure noise.
> 
> So lets drop the check for now - we can always add it back later
> should our headers be ready for that.
> 
> Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> Hi Ingo.
> Please include this in the  tip/core/header-fixes brach
> as this is the natural path towards mainline.
> 
> Jaswinder - thanks for your effort chasing all these warnings!

Applied to tip/core/header-fixes, thanks Sam for the quick patch!

Jaswinder, i think we now have a realistic chance to reach a zero baseline 
with these warnings, for v2.6.29. Here are the remaining warnings (summed 
up per file) on x86 (after Sam's patch):

     17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
     12 /dev/shm/tip/usr/include/linux/soundcard.h
      3 /dev/shm/tip/usr/include/linux/nubus.h
      2 /dev/shm/tip/usr/include/linux/in6.h
      1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
      1 /dev/shm/tip/usr/include/linux/socket.h
      1 /dev/shm/tip/usr/include/linux/coda_psdev.h
      1 /dev/shm/tip/usr/include/linux/bsg.h

	Ingo
