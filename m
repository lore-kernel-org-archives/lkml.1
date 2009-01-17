Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbZAQRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbZAQRLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 12:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762729AbZAQRLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 12:11:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:39742 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761960AbZAQRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 12:11:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ILuzdECreEemaGJkLZi1jTfsflt7QTYPsTCbyiGHr9CJLBqDlHgjaj3ckFeb0hVCBo
         9yw/qxrbjG9MQzM+jesEdfnp75EwQGSe0NJnkuepyd/qerp9mlpmZaLFtteSVhKw32W0
         mcYobSkiMg3LUm4Irgv+oqdeC17xHMRJHBy24=
Date: Sat, 17 Jan 2009 20:11:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] x86: fix 22 make headers_check warnings
Message-ID: <20090117171137.GB10502@localhost>
References: <1232209856.3388.5.camel@localhost.localdomain> <20090117164108.GG10825@elte.hu> <20090117164747.GA7192@localhost> <20090117170147.GM10825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117170147.GM10825@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Jan 17, 2009 at 06:01:47PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Sat, Jan 17, 2009 at 05:41:08PM +0100]
| > | 
| > | * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
| > | 
| > | > Hello Ingo,
| > | > 
| > | > The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
| > | >   Ingo Molnar (1):
| > | >         Merge branch 'x86/urgent'
| > | > 
| > | > are available in the git repository at:
| > | > 
| > | >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
| > | > 
| > | > Jaswinder Singh Rajput (8):
| > | >       x86: boot.h fix make headers_check
| > | >       x86: e820.h fix make headers_check
| > | >       x86: kvm.h fix make headers_check
| > | >       x86: mce.h fix make headers_check
| > | >       x86: mtrr.h fix make headers_check
| > | >       x86: ptrace-abi.h fix make headers_check
| > | >       x86: sigcontext.h fix make headers_check
| > | >       x86: swab.h fix make headers_check
| > | > 
| > | >  arch/x86/include/asm/boot.h       |    2 ++
| > | >  arch/x86/include/asm/e820.h       |   11 ++++++++---
| > | >  arch/x86/include/asm/kvm.h        |    2 +-
| > | >  arch/x86/include/asm/mce.h        |    5 +----
| > | >  arch/x86/include/asm/mtrr.h       |    1 +
| > | >  arch/x86/include/asm/ptrace-abi.h |    5 ++++-
| > | >  arch/x86/include/asm/sigcontext.h |    2 +-
| > | >  arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
| > | >  8 files changed, 37 insertions(+), 12 deletions(-)
| > | 
| > | Pulled into tip/core/header-fixes and started testing them, thanks 
| > | Jaswinder!
| > | 
| > | 	Ingo
| > | 
| > 
| > I thought some of them I've already fixed, no?
| 
| ah, indeed - tip/x86/setup-lzma is currently not in tip/master (due to a 
| breakage that is being investigated), that's why i missed it.
| 
| So i took out the boot.h change from core/headers-fixes and your fix will 
| take precedence.
| 
| btw:
| 
| > Cyrill Gorcunov wrote:
| > > Small series of headers cleanup, easy to bisect.
| > > make headers_check still complains about vars
| > > being found in comments but this is just a false
| > > alarm. Please review.
| > 
| > Applied patch 1 to tip:x86/setup-lzma, and patches 2, 4 and 5 to
| > tip:x86/header-fixes.
| 
| those x86/header-fixes bits from you are in core/headers-fixes now:
| 
|  dbca1df: x86: headers cleanup - setup.h
|  a7c4e68: x86: headers cleanup - sigcontext32.h
|  4440270: x86: headers cleanup - prctl.h
| 
| So i think we are all sorted, agreed?
| 
| 	Ingo
|

yep :) Personally I don't really care which
commits will be in tree (mine or Jaswinder).
The only what matter -- the work is done :)

There was some conversation about ptrace-abi.h.
Eventually we ended up that we should just remove
CONFIG_ for branch tracing since ptrace_bts_config
is supposed to be accessible from user space. At
least that is how I understood the conversation with
Peter.

		- Cyrill -
