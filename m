Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbYJMTWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbYJMTWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYJMTWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:22:25 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5808 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbYJMTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:22:25 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2008 20:22:22 +0100
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <1223925742287@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <20081013101722.2a1b3afa@infradead.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
	<87zll8r86h.fsf@basil.nowhere.org> <20081013091848.7dcdaaac@infradead.org>
	<20081013133051.GL12131@one.firstfloor.org>
	<20081013093014.607c5925@infradead.org>
	<20081013140228.GG29938@cs181140183.pp.htv.fi>
	<20081013101722.2a1b3afa@infradead.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrotes:
> On Mon, 13 Oct 2008 17:02:30 +0300
> Adrian Bunk <bunk <at> kernel.org> wrote:
> 
> > On Mon, Oct 13, 2008 at 09:30:14AM -0400, Arjan van de Ven wrote:
> > > On Mon, 13 Oct 2008 15:30:51 +0200
> > > Andi Kleen <andi <at> firstfloor.org> wrote:
> > > > 
> > > > > Core2 instruction set with tune=generic is still the best to
> > > > > set.
> > > > 
> > > > Not sure that is true. These option are mostly for the compiler.
> > > 
> > > exactly, and our benchmarks show that tune=generic is best right now
> > > for Atom. 
> > > (586 scheduling sounds nice, but the pipelines are rather different.
> > > And the benchmarks don't lie..  
> > 
> > That sounds a bit dangerous since tune=generic is documented to
> > change the semantics between gcc versions to better fit more recent
> > CPUs (there's even a small difference between gcc 4.2 and gcc 4.3):
> > 
> 
> reality is that tune=generic avoids the things that are "really bad"
> for a wide generation of cpus; the world of x86 is such that there
> really are many common things that are good for the vast majority of
> the cpus out there (or at least neutral). 
> 
> Future versions of GCC might have a specific ATOM model. Until they do,
> tune=generic is the right thing based on tests over a few gcc versions.
> Yes it's a bit fluid, but no gcc isn't going to suddenly go do stupid
> things for currently mass-sold cpus.

Well, if the Intel experts can't even agree, what hope do I have of 
getting it right :-(   I chose Core2 because I read somewhere that Atom 
was "feature compatible" with it, but of course that doesn't say 
anything about the optimal optimisations.  I trust that someone will 
update Kconfig.cpu with their idea of the right choice for Atom eventually.

(Maybe there should be a way to auto-suggest the right setting for a 
native build based on /proc/cpuinfo?  I think the gcc build process can 
do something like that.)

Cheers,  Phil.




