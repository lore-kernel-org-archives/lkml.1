Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbYEAXZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbYEAXZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYEAXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:24:52 -0400
Received: from fed1rmmtao107.cox.net ([68.230.241.39]:58346 "EHLO
	fed1rmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYEAXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:24:51 -0400
Date: Thu, 1 May 2008 16:24:47 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bunk@kernel.org,
       venkatesh.pallipadi@intel.com, davem@davemloft.net, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501232447.GF4354@smtp.west.cox.net>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501153349.f4537ec7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501153349.f4537ec7.akpm@linux-foundation.org>
Organization: Embedded Alley Solutions, Inc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:33:49PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 15:27:26 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > 
> > > > I see only the following choices:
> > > > - remove __weak and replace all current usages
> > > > - move all __weak functions into own files, and ensure that also happens
> > > >   for future usages
> > > > - #error for gcc 4.1.{0,1}
> > > 
> > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> > 
> > It's __GNUC_PATCHLEVEL__, I believe.
> > 
> > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> > (bad, and rather uncommon).
> > 
> > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> > begin with, I think it's better to just not support it.
> > 
> 
> Drat.  There go my alpha, i386, m68k, s390, sparc and powerpc
> cross-compilers.  Vagard, save me!
> 
> Meanwhile I guess I can locally unpatch that patch.

I know I'll come off as an ass, but you can't make new ones with 4.1.2?
It's not like we're talking about gcc 2.95/96 fun here :)

-- 
Tom Rini
