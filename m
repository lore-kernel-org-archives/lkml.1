Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbZAQRCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbZAQRCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 12:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbZAQRB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 12:01:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbZAQRBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 12:01:55 -0500
Date: Sat, 17 Jan 2009 18:01:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] x86: fix 22 make headers_check warnings
Message-ID: <20090117170147.GM10825@elte.hu>
References: <1232209856.3388.5.camel@localhost.localdomain> <20090117164108.GG10825@elte.hu> <20090117164747.GA7192@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117164747.GA7192@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Sat, Jan 17, 2009 at 05:41:08PM +0100]
> | 
> | * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> | 
> | > Hello Ingo,
> | > 
> | > The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
> | >   Ingo Molnar (1):
> | >         Merge branch 'x86/urgent'
> | > 
> | > are available in the git repository at:
> | > 
> | >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> | > 
> | > Jaswinder Singh Rajput (8):
> | >       x86: boot.h fix make headers_check
> | >       x86: e820.h fix make headers_check
> | >       x86: kvm.h fix make headers_check
> | >       x86: mce.h fix make headers_check
> | >       x86: mtrr.h fix make headers_check
> | >       x86: ptrace-abi.h fix make headers_check
> | >       x86: sigcontext.h fix make headers_check
> | >       x86: swab.h fix make headers_check
> | > 
> | >  arch/x86/include/asm/boot.h       |    2 ++
> | >  arch/x86/include/asm/e820.h       |   11 ++++++++---
> | >  arch/x86/include/asm/kvm.h        |    2 +-
> | >  arch/x86/include/asm/mce.h        |    5 +----
> | >  arch/x86/include/asm/mtrr.h       |    1 +
> | >  arch/x86/include/asm/ptrace-abi.h |    5 ++++-
> | >  arch/x86/include/asm/sigcontext.h |    2 +-
> | >  arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
> | >  8 files changed, 37 insertions(+), 12 deletions(-)
> | 
> | Pulled into tip/core/header-fixes and started testing them, thanks 
> | Jaswinder!
> | 
> | 	Ingo
> | 
> 
> I thought some of them I've already fixed, no?

ah, indeed - tip/x86/setup-lzma is currently not in tip/master (due to a 
breakage that is being investigated), that's why i missed it.

So i took out the boot.h change from core/headers-fixes and your fix will 
take precedence.

btw:

> Cyrill Gorcunov wrote:
> > Small series of headers cleanup, easy to bisect.
> > make headers_check still complains about vars
> > being found in comments but this is just a false
> > alarm. Please review.
> 
> Applied patch 1 to tip:x86/setup-lzma, and patches 2, 4 and 5 to
> tip:x86/header-fixes.

those x86/header-fixes bits from you are in core/headers-fixes now:

 dbca1df: x86: headers cleanup - setup.h
 a7c4e68: x86: headers cleanup - sigcontext32.h
 4440270: x86: headers cleanup - prctl.h

So i think we are all sorted, agreed?

	Ingo
