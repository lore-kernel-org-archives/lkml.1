Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0BNRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:09:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab0BNRJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:09:24 -0500
Date: Sun, 14 Feb 2010 18:08:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
Message-ID: <20100214170858.GA29006@elte.hu>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
 <1265793639-15071-28-git-send-email-yinghai@kernel.org>
 <20100215011615.e3d35121.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215011615.e3d35121.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi,
> 
> On Wed, 10 Feb 2010 01:20:31 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
> >
> > from arch/x86 to kernel/
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  arch/x86/include/asm/e820.h      |    2 +-
> >  arch/x86/include/asm/early_res.h |   21 --
> >  arch/x86/kernel/Makefile         |    2 +-
> >  arch/x86/kernel/e820.c           |    1 -
> >  arch/x86/kernel/early_res.c      |  523 --------------------------------------
> >  include/linux/early_res.h        |   21 ++
> >  kernel/Makefile                  |    2 +-
> >  kernel/early_res.c               |  522 +++++++++++++++++++++++++++++++++++++
> >  8 files changed, 546 insertions(+), 548 deletions(-)
> >  delete mode 100644 arch/x86/include/asm/early_res.h
> >  delete mode 100644 arch/x86/kernel/early_res.c
> >  create mode 100644 include/linux/early_res.h
> >  create mode 100644 kernel/early_res.c
> 
> From a powerpc pseries_defconfig build (and other configs) of tip/master
> (9d4a5dc3080c811f36bf8175f2de1f9a6f84b176 "Merge branch 'perf/urgent'"):
> 
> kernel/early_res.c:209: error: 'max_pfn_mapped' undeclared (first use in this function)
> 
> max_pfn_mapped is only defined for x86.

FYI, i already found this and reported it to Yinghai earlier today.

Btw.,are you doing these cross-build tests yourself, or are you relaying the 
kisskb automation notifications?

Thanks,

	Ingo
