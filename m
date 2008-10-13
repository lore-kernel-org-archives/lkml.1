Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYJMORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYJMORc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJMORX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:17:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYJMORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:17:23 -0400
Date: Mon, 13 Oct 2008 10:17:22 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Phil Endecott <phil_wueww_endecott@chezphil.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <20081013101722.2a1b3afa@infradead.org>
In-Reply-To: <20081013140228.GG29938@cs181140183.pp.htv.fi>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
	<87zll8r86h.fsf@basil.nowhere.org>
	<20081013091848.7dcdaaac@infradead.org>
	<20081013133051.GL12131@one.firstfloor.org>
	<20081013093014.607c5925@infradead.org>
	<20081013140228.GG29938@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 17:02:30 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Oct 13, 2008 at 09:30:14AM -0400, Arjan van de Ven wrote:
> > On Mon, 13 Oct 2008 15:30:51 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > Core2 instruction set with tune=generic is still the best to
> > > > set.
> > > 
> > > Not sure that is true. These option are mostly for the compiler.
> > 
> > exactly, and our benchmarks show that tune=generic is best right now
> > for Atom. 
> > (586 scheduling sounds nice, but the pipelines are rather different.
> > And the benchmarks don't lie..  ;-)
> 
> That sounds a bit dangerous since tune=generic is documented to
> change the semantics between gcc versions to better fit more recent
> CPUs (there's even a small difference between gcc 4.2 and gcc 4.3):
> 

reality is that tune=generic avoids the things that are "really bad"
for a wide generation of cpus; the world of x86 is such that there
really are many common things that are good for the vast majority of
the cpus out there (or at least neutral). 

Future versions of GCC might have a specific ATOM model. Until they do,
tune=generic is the right thing based on tests over a few gcc versions.
Yes it's a bit fluid, but no gcc isn't going to suddenly go do stupid
things for currently mass-sold cpus.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
