Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbXF1Cig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbXF1Cig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXF1Ci3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:38:29 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:47326 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759112AbXF1Ci2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:38:28 -0400
To: davids@webmaster.com
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKOELFEOAC.davids@webmaster.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Wed, 27 Jun 2007 23:37:42 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOELFEOAC.davids@webmaster.com> (David Schwartz's message of "Wed\, 27 Jun 2007 18\:37\:20 -0700")
Message-ID: <orsl8cztvt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Behind a barrier is not on a medium customarily used for software
> interchange, which 3a requires.

Are you per chance claiming that you've never heard of anyone
receiving encrypted software in a CD, or pre-installed in a computer?

>> > I honestly don't see what relevance this could possibly
>> > have. Getting access to the source is a fundamental GPL right.
>> 
>> That's the spirit.  But where does the *letter* of the GPL state it?

> 3a says it.

It says the sources must accompany the binaries (check), must be 
machine-readable (check), and must be on a medium customarily used for
software interchange (check).

Where does it say you have to be able to access the sources?  Or the
binary, for that matter?

> It makes no difference who imposes the restriction. Read section 7
> carefully. If *anything* imposes restrictions on the recipient's
> exercise of their GPL rights, you can't distribute.

This is actually not what section 7 says.  If it were so, the GPL
would forbid you from distributing any software whatsoever, because it
might reach someone in the US who would then be forbidden by law from
distributing it to someone in Cuba.  It would forbid you from
distributing cryptography software, or DVD descrambling software,
because the software might reach someone in a country where their
distribution is illegal.  Or it would forbid you from distributing
software that is covered by some patent in some distant country, just
because the software might reach a person there who might then be
stopped by the patent holder from distributing the software.

But the GPL doesn't forbid any such things.

The GPL stops you from distributing the software when you impose the
restriction yourself, or when you are required by a third party to
impose such a restriction.  For example, when you accept a patent
license that states you won't permit downstream users to distribute
the software, then you become a party that impose restrictions.  If
you don't have the source or written offer needed to comply with the
conditions of section 3, then you can't distribute the software.  It's
in this kind of situation that section 7 kicks in.

>> >> I ought to be entitled to modify any bit in the executable and
>> >> expect that to have the same effect as modifying that bit on that
>> >> executable on any other computer.

>> > Nope, sorry. If this were true, you ought to be entitled to
>> > modify a bit in
>> > the Linux kernel and have it have the same effect as modifying
>> > that Linux
>> > kernel on my desktop.

>> If your desktop is sufficiently similar, and the kernel binaries are
>> identical, why should I not expect the same result to arise?

> Because you have no way to get that software to run on my desktop,

Aah, I misunderstood what you wrote.  Yes, as long as you are entitled
to stop me from modifying software on your desktop, then I'm not
entitled to modify it.

However, once I'm entitled to make an identical change to the
identical software running on both your (or my) desktop and another
nearly-identical computer, if they behaved exactly the same before the
modification, I'm reasonably entitled to expect them to do behave
exactly the same after the modification.  If they don't, and I find
out that it's because the party who distributed the software to me
introduced mechanisms to prevent me from modifying the software, how
is that not a "further restriction"?

>> 2. You may modify your copy or copies of the Program or any portion
>> of it          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> This is pretty clear that no copy is special. In any event, this is a grant
> of license, not a guarantee of ability. (Read the context.)

Yes, it's a grant of license.  And then, section 6 tells a licensee
that, when he distributes the software to someone else, she receives a
license to modify that copy of the software, as well as to make
further copies and modify them, and he must not impose any further
restrictions on the exercise of the granted rights.  QED

> Otherwise, you could get around the GPL just by having someone else
> impose restrictions.

Oh, wow, really?  Are you familiar with the Microsoft Novell deal?  Is
this not exactly how they got around the GPL?

The only reason GPLv3 can oppose distribution under these conditions
is precisely the existence of the deal, which turns both Microsoft and
Novell parties of an arrangement to distribute the software in a way
that imposes further restrictions on the recipient's rights granted by
the license.  Unfortunately, I'm told GPLv2 is vulnerable to this
particular deal.

Also remember that it's not enough for Microsoft or anyone else to
have patents that might be used to impose restrictions on others'
exercise of their rights for the GPL to say you can't distribute the
software.  You must (voluntarily or not) accept a restrictive license
before section 7 kicks in and stops you from distributing the software
under the restrictions imposed on you.

> We agreed that if anything prevented your recipients from exercising
> your GPL rights, that means you cannot distribute.

I didn't agree to that, and now I've explained why this would be a
terribly stupid idea.  That's just not how the GPL works.

Draw satisfaction from the fact that you're not giving legal advice
:-)

FWIW, I'm not either, IANAL.

> If the right/ability to modify a particular copy is a GPL right,
> then you cannot distribute on CDROM.

Who's stopping you from modifying the copy in a CDROM?  Is it the
distributor?  Did it set things up such that you wouldn't be able to
modify that CDROM?  Or could it be just because nobody has found a way
to overcome the natural (?) limitation of CDROMs (or rather of CDR
drives?)?  If you find it out, you're free to use it.  In the mean
time, you can still create other copies of the software in the CDROM
and modify those.

> If we were to read "may modify your copy or copies of the Program or
> any portion of it" the way you suggest, that would mean that you
> must be able to modify every single copy of the program that is
> distributed to you.

No, it only means that the distributor must not impose restrictions on
my ability to modify those copies.  The copyright holder says I can.
Both nature and distributor might have means to stop me from doing it.
Copyright holder can't override nature, but it can override the
distributor.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
