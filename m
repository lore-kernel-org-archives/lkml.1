Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZAHQnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZAHQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZAHQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:43:34 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40860 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZAHQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:43:34 -0500
Date: Thu, 8 Jan 2009 17:45:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090108164514.GA18409@uranus.ravnborg.org>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231424833.11687.452.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 03:27:13PM +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-08 at 15:21 +0100, Jiri Kosina wrote:
> > On Thu, 8 Jan 2009, Peter Zijlstra wrote:
> > 
> > > > Subject: x86: make spinlocks available on machines without xadd insn
> > > > Current kernel wouldn't compile on ancient x86 machines that don't support 
> > > > xadd instruction, as ticket spinlocks implementation unconditionally uses 
> > > > it.
> > > > On machines without CONFIG_X86_XADD, use old-style byte spinlock 
> > > > implementation instead.
> > > afaik we don't support i386-smp and up spinlocks are trivial
> > > preempt_disable() calls.
> > 
> > Hmm. Where in Kconfig is SMP for M386 not allowed?
> 
> Dunno, kconfig is too much of a jungle for a simple person like me ;-)

Kconfig for x86 does nothing to prevent us from selecting SMP
when we have selected the 386 processor variant.

But then you need to enable the CONFIG_EXPERT(*) option to
select CPU type - which imply you know what you are doing.

(*) Named CONFIG_EMBEDDED for some reason.

	Sam
