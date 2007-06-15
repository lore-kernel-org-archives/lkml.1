Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXFOKEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXFOKEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbXFOKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:04:16 -0400
Received: from keil-draco.com ([216.193.185.50]:50128 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXFOKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:04:15 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 06:03:59 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706150458.29943.dhazelton@enter.net> <1181899064.25228.342.camel@pmac.infradead.org>
In-Reply-To: <1181899064.25228.342.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150604.00086.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 05:17:44 David Woodhouse wrote:
> On Fri, 2007-06-15 at 04:58 -0400, Daniel Hazelton wrote:
> > > If the module is distributed 'as a separate work', _then_ what you say
> > > is true: the only reason you'd have a right to the source is if the
> > > module is considered a 'derivative work'.
> > >
> > > But when you distribute the same module as part of a whole which is a
> > > work based on the kernel, the distribution of the whole must be on the
> > > terms of GPL, whose permissions for other licensees extend to the
> > > entire whole, and thus to each and every part regardless of who wrote
> > > it.
> >
> > -ELOGIC
>
> What's logic got to do with it? It was fairly much a direct quote from
> the licence. You have _read_ the licence, haven't you?

Hrm... Perhaps I misread your post originally. Let me read it again and see if 
I didn't encounter a parsing error somewhere... Nope. Error of omission. The 
text you cut changes the meaning of the passage in its entirety.

Here, I'll quote it, in it's entirety:

These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

In other words, it applies to *SECTIONS* of the code, not to individual object 
code files. This is why kernel modules can have their own, separate license 
from the kernel. It isn't until the code is shipped as a *standard* part of 
the kernel that it has to be GPLv2. (Dynamic Linking, being a totally 
mechanical process, cannot create a derivative work under US copyright law, 
so please, don't try that old saw)

What this means is that it doesn't matter that a non-GPL module is shipped, 
in "object code" form with the "object code" form of the linux kernel it is 
designed to interface with - it *still* doesn't become automatically covered 
by the GPL.

> > > The words you used were 'with the kernel', which could actually mean
> > > either of the above. In the case of embedded Linux-based firmware
> > > though, it's definitely the latter. It's a coherent whole, and it
> > > contains both the kernel and the module. Thus the GPL extends to each
> > > and every part, regardless of who wrote it. Including the module.
> >
> > Just because two things are bundled together doesn't put them under the
> > same license or copyright. Take a look at the GPL, which specifically
> > mentions that "mere aggregation" does not cause something to fall under
> > the GPL. Not that the GPL can even change the law - in the US copyright
> > law specifically states that "mechanical translation" and "mechanical
> > processes" *CANNOT* create a "new" work. Since the process of compiling
> > source into a binary is, by definition, a *mechanical* process then the
> > binary can't suddenly become covered by a different copyright license
> > than the source code merely because of the medium on which its
> > distributed or the manner in which it is distributed.
>
> You're confused.

Nope. Not confused at all.

> If I grant you a licence on the condition that you give me money, would
> you object on the basis that the money is not a 'derived work' of my
> code? No. It's just a condition of the licence, and you're not allowed
> to use my code unless you give me money.

But you obviously are. After all, what does this have to do with whether the 
GPLv2 can "magically" change the law? 

> If I grant you a licence on the condition that you sacrifice your
> first-born son to Satan, would you object on the basis that your son is
> not a 'derived work' of my code? No. It's just a condition of the
> licence. If you don't do it, you don't have the right to use my code.
> (You may be able to get me locked up, but you still don't get to use my
> code without a licence).
>
> If I grant you a licence on the condition that you release _everything_
> you write this year under the GPLv2, would you object on the basis that
> your code is not a 'derived work' of my own? No. It's just a condition
> of the licence, which you choose to accept or not.

Again, what does this have to do with your apparent belief that me putting a 
binary of a kernel module that isn't GPL'd on a disc with the Linux kernel 
causes that module to become covered by the GPL?

> If I grant you a licence on the condition that anything you release in
> _combination_ with my code must also be released under the GPL, would
> you object on the basis that you code is not a 'derived work' of my own?
> No. Again, it's just a condition of the licence. If you don't want to
> obey the licence, you don't get to use the kernel in the first place.
>
> Talking about how your code can't possibly be a derived work is just a
> red herring. The GPL explicitly talks about works which are 'independent
> and separate works in themselves', to which the GPL does not apply 'when
> you distribute them as separate works'.

And it also says:
In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

In other words, even though I've built a program that isn't GPL'd, I can still 
put it on the same "volume of storage or distribution medium" as a GPL'd work 
and not have to put it under the GPL. Imagine that.

And again, I have to point out that, no matter what RMS and the rest of the 
people that wrote the GPLv2 may believe, it can't change the law on which it 
is based. If the law says "mechanical translation or processes cannot produce 
a new work", then no matter what the GPLv2 says, I can write a parser 
skeleton in the "YACC" language, run it through Bison and *NOT* need 
the "exception" that the FSF "thoughtfully" provides. Why? Because the 
*skeleton* I wrote carries the copyright - not the output of Bison, despite 
what the GPL *might* say on this in Section 0. A license *cannot* change the 
law, because it gets all its power from the law.

> But when you distribute the same sections as part of a whole which is a
> work based on the Program, the distribution of the whole must be on the
> terms of this License, whose permissions for other licensees extend to
> the entire whole, and thus to each and every part regardless of who
> wrote it.

Hrm... I see, you've included the section unmolested here - but you still seem 
unable to read it correctly. Perhaps I'm wrong though.

> It's your choice -- you're not _forced_ to use the kernel, and you're
> not _forced_ to distribute a product which combines it with other code
> of your own. But if you do, you're bound by the licence. And whether
> your code is a 'derived work' has nothing to do with it.

And is this what the process of making a module does? Because that *IS* what I 
had mentioned. If the mail I'm responding to was a response to that mail then 
you are sadly confused as to what I was talking about. 

> Yes, there are exceptions for mere aggregation onto a storage medium --
> if the kernel and your own work are next to each other on a backup tape
> or your laptop's hard drive, or even both burned to a 'Gratis Software'
> CD as _separate_ works, then that doesn't count. But we're talking about
> a product which has a Linux kernel, a module built specifically for that
> kernel, and cannot function unless both of them are present. That ain't
> "mere aggregation on a storage medium".

Yet it still doesn't make them a "combined work". If it did then the simple 
act of me installing a copy of the ATI or NVidia modules makes them GPL'd. 
But it doesn't - if it did I'm sure that somebody would have filed a lawsuit 
over this already.

DRH


-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
