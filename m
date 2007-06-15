Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXFOKtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXFOKtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXFOKt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:49:27 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60087 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXFOKt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:49:26 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <200706150604.00086.dhazelton@enter.net>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706150458.29943.dhazelton@enter.net>
	 <1181899064.25228.342.camel@pmac.infradead.org>
	 <200706150604.00086.dhazelton@enter.net>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 11:49:05 +0100
Message-Id: <1181904545.25228.413.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 06:03 -0400, Daniel Hazelton wrote:
> In other words, it applies to *SECTIONS* of the code, not to individual object 
> code files. This is why kernel modules can have their own, separate license 
> from the kernel. It isn't until the code is shipped as a *standard* part of 
> the kernel that it has to be GPLv2. (Dynamic Linking, being a totally 
> mechanical process, cannot create a derivative work under US copyright law, 
> so please, don't try that old saw)
> 
> What this means is that it doesn't matter that a non-GPL module is shipped, 
> in "object code" form with the "object code" form of the linux kernel it is 
> designed to interface with - it *still* doesn't become automatically covered 
> by the GPL.

You're interpreting 'sections' to mean individual linker sections? And
you think it's talking about distributing those 'sections' "as separate
works"? Despite the fact that all the rest of the language in the
document is high-level and doesn't even mention _linking_? 

That's... an interesting interpretation.

> > If I grant you a licence on the condition that you give me money, would
> > you object on the basis that the money is not a 'derived work' of my
> > code? No. It's just a condition of the licence, and you're not allowed
> > to use my code unless you give me money.
> 
> But you obviously are. After all, what does this have to do with whether the 
> GPLv2 can "magically" change the law? 

The GPLv2 doesn't "magically" change the law, and has no need to. The
above is just a demonstration that a licence can have conditions which
involve things _other_ than derived works.

I can release code under a 'viral' licence which requires you to release
_everything_ you write for a whole year under that same licence. You
don't _have_ to obey, and there's no suggestion that your own code would
be 'derived' from mine -- but if you don't follow the conditions of the
licence, then you don't get permission to use my code. There's no
"magical" change to the law required.

> > If I grant you a licence on the condition that you sacrifice your
> > first-born son to Satan, would you object on the basis that your son is
> > not a 'derived work' of my code? No. It's just a condition of the
> > licence. If you don't do it, you don't have the right to use my code.
> > (You may be able to get me locked up, but you still don't get to use my
> > code without a licence).
> >
> > If I grant you a licence on the condition that you release _everything_
> > you write this year under the GPLv2, would you object on the basis that
> > your code is not a 'derived work' of my own? No. It's just a condition
> > of the licence, which you choose to accept or not.
> 
> Again, what does this have to do with your apparent belief that me putting a 
> binary of a kernel module that isn't GPL'd on a disc with the Linux kernel 
> causes that module to become covered by the GPL?

It's just a demonstration that a licence _can_ make requirements about
non-derived code. You seemed to be making two bogus claims -- first that
it _can_ not, and then that the GPL _does_ not.

I've dealt with the first; let's look at the second, leaving aside your
weird digression about bison... (hint: it's about the code stubs in the
output which weren't _produced_ mechanically in the first place; they
were only _put_ there mechanically by the software).

> > Talking about how your code can't possibly be a derived work is just a
> > red herring. The GPL explicitly talks about works which are 'independent
> > and separate works in themselves', to which the GPL does not apply 'when
> > you distribute them as separate works'.
> 
> And it also says:
> In addition, mere aggregation of another work not based on the Program
> with the Program (or with a work based on the Program) on a volume of
> a storage or distribution medium does not bring the other work under
> the scope of this License.
> 
> In other words, even though I've built a program that isn't GPL'd, I can still 
> put it on the same "volume of storage or distribution medium" as a GPL'd work 
> and not have to put it under the GPL. Imagine that.

Yes. That's why I said 'not necessarily' rather than 'no'. If it just
happens to be on the same hard drive / tape / CD-ROM that's not
important. The important question is whether it's distributed 'as a
separate work' or whether it's part of a larger, coherent whole.

> > But when you distribute the same sections as part of a whole which is a
> > work based on the Program, the distribution of the whole must be on the
> > terms of this License, whose permissions for other licensees extend to
> > the entire whole, and thus to each and every part regardless of who
> > wrote it.
> 
> Hrm... I see, you've included the section unmolested here - but you still seem 
> unable to read it correctly. Perhaps I'm wrong though.

If by 'correctly' you mean I should interpret 'sections' to mean linker
sections, then you're right -- I really can't bring myself to read it
that way. Of course, you're not actually _wrong_ until/unless it's
interpreted in court. But I'm willing to place bets :)

> > It's your choice -- you're not _forced_ to use the kernel, and you're
> > not _forced_ to distribute a product which combines it with other code
> > of your own. But if you do, you're bound by the licence. And whether
> > your code is a 'derived work' has nothing to do with it.
> 
> And is this what the process of making a module does? Because that *IS* what I 
> had mentioned. If the mail I'm responding to was a response to that mail then 
> you are sadly confused as to what I was talking about. 

I'm certainly confused as to what you're talking about _now_; it seems
to make little sense. What do you mean by 'this' in the context of 'is
this what the process of making a module does?'? And how is it relevant?

You said that modules aren't derivative works. I said 'Who cares?'
because there are far more obvious reasons why the module would be under
GPL, because of the GPL's requirements about collective works. What part
of that confuses you? You seem to _keep_ going back to talking about
derived works.

> > Yes, there are exceptions for mere aggregation onto a storage medium --
> > if the kernel and your own work are next to each other on a backup tape
> > or your laptop's hard drive, or even both burned to a 'Gratis Software'
> > CD as _separate_ works, then that doesn't count. But we're talking about
> > a product which has a Linux kernel, a module built specifically for that
> > kernel, and cannot function unless both of them are present. That ain't
> > "mere aggregation on a storage medium".
> 
> Yet it still doesn't make them a "combined work". If it did then the simple 
> act of me installing a copy of the ATI or NVidia modules makes them GPL'd. 
> But it doesn't - if it did I'm sure that somebody would have filed a lawsuit 
> over this already.

The GPL applies if you _distribute_ a work which combines such modules
and the kernel into a larger whole. You can do what you like if you
don't distribute it.

The 'mere aggregation' thing means you can even distribute them together
if they just happen to be side-by-side on a storage medium as if by
coincidence. But putting them together into a product which actually
uses and requires both of them is not 'mere aggregation'. Some people
_were_ bundling the ATI and nVidia modules together with the kernel in a
'product', and they stopped under threat of legal action.

The module on its own is questionable -- it is a matter of opinion
whether that's a derived work or not. But when you ship a product which
combines both kernel and module into a coherent whole, it doesn't
_matter_ if the module is a derived work or not. You are not permitted
to distribute the kernel unless your module is also licensed under the
GPL. Not because it's a derived work, but because the licence of the
kernel says that's the price you pay if you want to distribute the
kernel.

-- 
dwmw2

