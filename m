Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbZAOOSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbZAOOSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbZAOOR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:17:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759430AbZAOORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:17:55 -0500
Date: Thu, 15 Jan 2009 15:17:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan-Benedict Glaw <jbglaw@lug-owl.de>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090115141734.GA15732@elte.hu>
References: <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Thu, 15 Jan 2009, Alan Cox wrote:
> 
> > >  UP emulation of CMPXCHG and XADD for userland should be rather trivial, 
> > > so why not include it like with LL/SC for MIPS?
> > 
> > Why not just ship an additional libc with the right options ?
> 
>  Does not work for MIPS as glibc has no equivalent code for pre-LL/SC 
> CPUs and LL/SC is always used.  For the i386 the situation seems worse 
> yet as for pre-i486 CPUs a generic C implementation of 
> compare-and-exchange is used guaranteeing silent thread unsafety. :(
> 
>  IMO, a kernel emulation of CMPXCHG and XADD (both are used by 
> sysdeps/i386/i486/bits/atomic.h in glibc) with an optional LOCK prefix, 
> guaranteeing UP atomicity would be a cheap way to provide long-term i386 
> userland support with little burden for both Linux and respective user 
> software maintainers.  Certainly it adds some bloat to the kernel, but I 
> think it is not an option that should be outright dismissed without 
> consideration.

patches are welcome ...

	Ingo
