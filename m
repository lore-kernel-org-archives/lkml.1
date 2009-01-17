Return-Path: <linux-kernel-owner+w=401wt.eu-S1765251AbZAQQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251AbZAQQsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbZAQQrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:47:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:24319 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbZAQQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tMWHUDL54w+bnRAgD/lfppRr6LrRDAIRcuYOhwl18kXWlayyR16XtPftU9FY+Hvlb7
         uG7aoGwuJcys+85lP0M1d6YNsoW6bUMSIVNz0yiTkG7hVu9kIqGWexpdBEPqXtg3KYe6
         47kEcVrR+DAhQMvrUre6pEFqhL0LCVkCtjI9w=
Date: Sat, 17 Jan 2009 19:47:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] x86: fix 22 make headers_check warnings
Message-ID: <20090117164747.GA7192@localhost>
References: <1232209856.3388.5.camel@localhost.localdomain> <20090117164108.GG10825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117164108.GG10825@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Jan 17, 2009 at 05:41:08PM +0100]
| 
| * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
| 
| > Hello Ingo,
| > 
| > The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
| >   Ingo Molnar (1):
| >         Merge branch 'x86/urgent'
| > 
| > are available in the git repository at:
| > 
| >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
| > 
| > Jaswinder Singh Rajput (8):
| >       x86: boot.h fix make headers_check
| >       x86: e820.h fix make headers_check
| >       x86: kvm.h fix make headers_check
| >       x86: mce.h fix make headers_check
| >       x86: mtrr.h fix make headers_check
| >       x86: ptrace-abi.h fix make headers_check
| >       x86: sigcontext.h fix make headers_check
| >       x86: swab.h fix make headers_check
| > 
| >  arch/x86/include/asm/boot.h       |    2 ++
| >  arch/x86/include/asm/e820.h       |   11 ++++++++---
| >  arch/x86/include/asm/kvm.h        |    2 +-
| >  arch/x86/include/asm/mce.h        |    5 +----
| >  arch/x86/include/asm/mtrr.h       |    1 +
| >  arch/x86/include/asm/ptrace-abi.h |    5 ++++-
| >  arch/x86/include/asm/sigcontext.h |    2 +-
| >  arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
| >  8 files changed, 37 insertions(+), 12 deletions(-)
| 
| Pulled into tip/core/header-fixes and started testing them, thanks 
| Jaswinder!
| 
| 	Ingo
| 

I thought some of them I've already fixed, no?

...
From: "H. Peter Anvin" <hpa@zytor.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, harvey.harrison@gmail.com,
        sam@ravnborg.org, jaswinderrajput@gmail.com
Subject: Re: [patch 0/5] x86 -tip: headers cleanup
Date: Wed, 14 Jan 2009 15:41:34 -0800

Cyrill Gorcunov wrote:
> Small series of headers cleanup, easy to bisect.
> make headers_check still complains about vars
> being found in comments but this is just a false
> alarm. Please review.

Applied patch 1 to tip:x86/setup-lzma, and patches 2, 4 and 5 to
tip:x86/header-fixes.

		- Cyrill -
