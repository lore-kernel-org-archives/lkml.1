Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZAHO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZAHO1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZAHO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:27:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:44756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZAHO1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:27:15 -0500
Subject: Re: Is 386 processor still supported?
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz>
References: <20090108120338.6b8b4567@zonk.pl>
	 <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
	 <1231424025.11687.447.camel@twins>
	 <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 15:27:13 +0100
Message-Id: <1231424833.11687.452.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 15:21 +0100, Jiri Kosina wrote:
> On Thu, 8 Jan 2009, Peter Zijlstra wrote:
> 
> > > Subject: x86: make spinlocks available on machines without xadd insn
> > > Current kernel wouldn't compile on ancient x86 machines that don't support 
> > > xadd instruction, as ticket spinlocks implementation unconditionally uses 
> > > it.
> > > On machines without CONFIG_X86_XADD, use old-style byte spinlock 
> > > implementation instead.
> > afaik we don't support i386-smp and up spinlocks are trivial
> > preempt_disable() calls.
> 
> Hmm. Where in Kconfig is SMP for M386 not allowed?

Dunno, kconfig is too much of a jungle for a simple person like me ;-)

But afaik i386 (and possibly i486) don't support nearly enough for a
modern SMP system.

Alan used to have i486-smp I think, one of the very few ever made.

