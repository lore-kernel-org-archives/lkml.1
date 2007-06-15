Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXFOUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXFOUYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXFOUYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:24:33 -0400
Received: from keil-draco.com ([216.193.185.50]:50203 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXFOUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:24:31 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 16:24:13 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706150604.00086.dhazelton@enter.net> <1181904545.25228.413.camel@pmac.infradead.org>
In-Reply-To: <1181904545.25228.413.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151624.14180.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 06:49:05 David Woodhouse wrote:
> On Fri, 2007-06-15 at 06:03 -0400, Daniel Hazelton wrote:
> > In other words, it applies to *SECTIONS* of the code, not to individual
> > object code files. This is why kernel modules can have their own,
> > separate license from the kernel. It isn't until the code is shipped as a
> > *standard* part of the kernel that it has to be GPLv2. (Dynamic Linking,
> > being a totally mechanical process, cannot create a derivative work under
> > US copyright law, so please, don't try that old saw)
> >
> > What this means is that it doesn't matter that a non-GPL module is
> > shipped, in "object code" form with the "object code" form of the linux
> > kernel it is designed to interface with - it *still* doesn't become
> > automatically covered by the GPL.
>
> You're interpreting 'sections' to mean individual linker sections? And
> you think it's talking about distributing those 'sections' "as separate
> works"? Despite the fact that all the rest of the language in the
> document is high-level and doesn't even mention _linking_?
>
> That's... an interesting interpretation.

And it's your own, twisted interpretation. When I say "Sections" I 
mean "portions of the source code", ie: files, functions, etc... In that 
manner the person who wrote that function, file, etc... (provided it meets 
the "minimum of artistic expression" required by US copyright law) has 
copyright to it. If it doesn't become compiled into - ie: linked into as a 
*standard* part of the build - the final executable the license on the final 
executable *cannot* have any effect on the stated code. QED: a kernel module, 
like "i8042.ko" *can* and *does* have a separate copyright *and* license from 
the linux kernel itself.

> > > If I grant you a licence on the condition that you give me money, would
> > > you object on the basis that the money is not a 'derived work' of my
> > > code? No. It's just a condition of the licence, and you're not allowed
> > > to use my code unless you give me money.
> >
> > But you obviously are. After all, what does this have to do with whether
> > the GPLv2 can "magically" change the law?
>
> The GPLv2 doesn't "magically" change the law, and has no need to. The
> above is just a demonstration that a licence can have conditions which
> involve things _other_ than derived works.
>
> I can release code under a 'viral' licence which requires you to release
> _everything_ you write for a whole year under that same licence. You
> don't _have_ to obey, and there's no suggestion that your own code would
> be 'derived' from mine -- but if you don't follow the conditions of the
> licence, then you don't get permission to use my code. There's no
> "magical" change to the law required.
>
> > > If I grant you a licence on the condition that you sacrifice your
> > > first-born son to Satan, would you object on the basis that your son is
> > > not a 'derived work' of my code? No. It's just a condition of the
> > > licence. If you don't do it, you don't have the right to use my code.
> > > (You may be able to get me locked up, but you still don't get to use my
> > > code without a licence).
> > >
> > > If I grant you a licence on the condition that you release _everything_
> > > you write this year under the GPLv2, would you object on the basis that
> > > your code is not a 'derived work' of my own? No. It's just a condition
> > > of the licence, which you choose to accept or not.
> >
> > Again, what does this have to do with your apparent belief that me
> > putting a binary of a kernel module that isn't GPL'd on a disc with the
> > Linux kernel causes that module to become covered by the GPL?
>
> It's just a demonstration that a licence _can_ make requirements about
> non-derived code. You seemed to be making two bogus claims -- first that
> it _can_ not, and then that the GPL _does_ not.

I never said it couldn't - a license can do whatever the hell it wants. What I 
said was that the license on one copyright work *cannot* just magically 
change the license on another work. The change of license *requires* the 
person holding copyright to *agree* to the change of license.

And no, the GPL *DOES* *NOT* have the requirement that a non-GPL'd work 
included on the same medium - for distribution or otherwise - must change its 
license to the GPL. If you think otherwise then you are sadly mistaken.

> I've dealt with the first; let's look at the second, leaving aside your
> weird digression about bison... (hint: it's about the code stubs in the
> output which weren't _produced_ mechanically in the first place; they
> were only _put_ there mechanically by the software).

About bison: doesn't matter. The code that they are included in *is* 
mechanically generated, as guided by the input file. QED: The output of Bison 
is a mechanical translation process *exactly* like the compiling of a C 
source file is a mechanical translation.

> > > Talking about how your code can't possibly be a derived work is just a
> > > red herring. The GPL explicitly talks about works which are
> > > 'independent and separate works in themselves', to which the GPL does
> > > not apply 'when you distribute them as separate works'.
> >
> > And it also says:
> > In addition, mere aggregation of another work not based on the Program
> > with the Program (or with a work based on the Program) on a volume of
> > a storage or distribution medium does not bring the other work under
> > the scope of this License.
> >
> > In other words, even though I've built a program that isn't GPL'd, I can
> > still put it on the same "volume of storage or distribution medium" as a
> > GPL'd work and not have to put it under the GPL. Imagine that.
>
> Yes. That's why I said 'not necessarily' rather than 'no'. If it just
> happens to be on the same hard drive / tape / CD-ROM that's not
> important. The important question is whether it's distributed 'as a
> separate work' or whether it's part of a larger, coherent whole.

And the GPL cannot define, on its own, what a "Separate Work" or a "Coherent 
Whole" is. That is defined by the relevant parts of copyright law. QED: The 
passage is largely irrelevant - if not, then the FSF claim that linking to a 
GPL'd library means your program is "magically" now GPL'd. It would also mean 
that every Linux live-cd that includes a non-GPL program is violating the 
GPL.

> > > But when you distribute the same sections as part of a whole which is a
> > > work based on the Program, the distribution of the whole must be on the
> > > terms of this License, whose permissions for other licensees extend to
> > > the entire whole, and thus to each and every part regardless of who
> > > wrote it.
> >
> > Hrm... I see, you've included the section unmolested here - but you still
> > seem unable to read it correctly. Perhaps I'm wrong though.
>
> If by 'correctly' you mean I should interpret 'sections' to mean linker
> sections, then you're right -- I really can't bring myself to read it
> that way. Of course, you're not actually _wrong_ until/unless it's
> interpreted in court. But I'm willing to place bets :)

Nope. To mean "source code files" or "functions in the source code". "Linker 
Sections" is your idea.

> > > It's your choice -- you're not _forced_ to use the kernel, and you're
> > > not _forced_ to distribute a product which combines it with other code
> > > of your own. But if you do, you're bound by the licence. And whether
> > > your code is a 'derived work' has nothing to do with it.
> >
> > And is this what the process of making a module does? Because that *IS*
> > what I had mentioned. If the mail I'm responding to was a response to
> > that mail then you are sadly confused as to what I was talking about.
>
> I'm certainly confused as to what you're talking about _now_; it seems
> to make little sense. What do you mean by 'this' in the context of 'is
> this what the process of making a module does?'? And how is it relevant?

The confusion is probably because you assumed I was an idiot who didn't have a 
clue what he was talking about. "This" means, if you really don't 
understand, "combining a GPL'd work with code of your own". So, does creating 
a kernel module that needs to be loaded into memory *separately* from the 
kernel "combine GPL'd code with your own". If that's what you think then you 
are wrong - see my comments about "mechanical processes" and such.

> You said that modules aren't derivative works. I said 'Who cares?'
> because there are far more obvious reasons why the module would be under
> GPL, because of the GPL's requirements about collective works. What part
> of that confuses you? You seem to _keep_ going back to talking about
> derived works.

Because the *only* relevant passages in the GPL, as applied to not-in-tree 
kernel modules is that about "derived works". *IF* distributing GPL'd 
binaries as part of an "Operating System" created a "collective work" then 
the FreeBSD people, who - last I looked - shipped with GCC as part of the OS, 
are in direct violation of the GPL. That means that either your argument is 
wrong or that every non-GPL'd OS that ships with GCC as an integral part is 
in violation of the GPL. 

> > > Yes, there are exceptions for mere aggregation onto a storage medium --
> > > if the kernel and your own work are next to each other on a backup tape
> > > or your laptop's hard drive, or even both burned to a 'Gratis Software'
> > > CD as _separate_ works, then that doesn't count. But we're talking
> > > about a product which has a Linux kernel, a module built specifically
> > > for that kernel, and cannot function unless both of them are present.
> > > That ain't "mere aggregation on a storage medium".
> >
> > Yet it still doesn't make them a "combined work". If it did then the
> > simple act of me installing a copy of the ATI or NVidia modules makes
> > them GPL'd. But it doesn't - if it did I'm sure that somebody would have
> > filed a lawsuit over this already.
>
> The GPL applies if you _distribute_ a work which combines such modules
> and the kernel into a larger whole. You can do what you like if you
> don't distribute it.
>
> The 'mere aggregation' thing means you can even distribute them together
> if they just happen to be side-by-side on a storage medium as if by
> coincidence. But putting them together into a product which actually
> uses and requires both of them is not 'mere aggregation'. Some people
> _were_ bundling the ATI and nVidia modules together with the kernel in a
> 'product', and they stopped under threat of legal action.
>
> The module on its own is questionable -- it is a matter of opinion
> whether that's a derived work or not. But when you ship a product which
> combines both kernel and module into a coherent whole, it doesn't
> _matter_ if the module is a derived work or not. You are not permitted
> to distribute the kernel unless your module is also licensed under the
> GPL. Not because it's a derived work, but because the licence of the
> kernel says that's the price you pay if you want to distribute the
> kernel.

Hrm... I see your point. When applied *solely* to the kernel and associated 
modules. But I can *still* see problems with that interpretation - very big 
ones that a good lawyer could exploit.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
