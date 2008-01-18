Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbYARWka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbYARWka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762589AbYARWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:40:20 -0500
Received: from waste.org ([66.93.16.53]:48878 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762896AbYARWkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:40:19 -0500
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080118210938.GE10717@elte.hu>
References: <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>
	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>
	 <4790A385.800@free-electrons.com>
	 <1200664214.4001.24.camel@cinder.waste.org>
	 <4790D3E3.4060409@free-electrons.com>
	 <1200676219.3835.8.camel@cinder.waste.org> <20080118210938.GE10717@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 16:39:10 -0600
Message-Id: <1200695950.25782.28.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 22:09 +0100, Ingo Molnar wrote:
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > Sounds fine! Don't hesitate to let us know about the lower-hanging 
> > > fruit you're thinking about. Here are the main things I have so far:
> > > 
> > >     * Ideas in the existing Linux-Tiny patchset.
> > >     * Disable support for non-Intel processors in x86 (cyrix.c,
> > >       centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
> > >       As far as I remember, I saved 15 KB when I first experimented with
> > >       this).
> > 
> > Isn't that already in -tiny?
> 
> btw., are there any pending arch/x86 bits in -tiny? (stupid question: 
> were can i get the most uptodate version of -tiny from?)

It's not a stupid question. I dropped updating the tree regulary some
time ago to focus on merging bits and then got a bit side-tracked by
this little thing called "version control".

Michael is attempting to get the tree started again and has put a quilt
up here:

http://elinux.org/images/3/3c/Tiny-quilt-2.6.23-0.tar.bz2

-- 
Mathematics is the supreme nostalgia of our time.

