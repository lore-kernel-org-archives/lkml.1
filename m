Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXBVW2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXBVW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXBVW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:28:08 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:42514 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXBVW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ojKuFXcxkUt3y1fV/YE+LYBO//wjL239Sppd16oQZkIcDKJMjNu380NVOlkASe3Mc+wEF1pqkmTfhK78YB8jrwy024SjfV+Fek7AHCZ8GAGrdi7i0sSMALcE7TKXzuWUm4gC7vPqPAprZhX4Y8aLM6iRXWgVqzRNm9qCBzxzvtk=
Message-ID: <f2b55d220702221428x486c7545jbe76a5c3c5d9ce27@mail.gmail.com>
Date: Thu, 22 Feb 2007 14:28:02 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "D. Hazelton" <dhazelton@enter.net>
Subject: Re: GPL vs non-GPL device drivers
Cc: Alan <alan@lxorguk.ukuu.org.uk>,
       "David Lang" <david.lang@digitalinsight.com>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <200702221636.37306.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <200702212030.58317.dhazelton@enter.net>
	 <20070222141047.425337a0@lxorguk.ukuu.org.uk>
	 <200702221636.37306.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, D. Hazelton <dhazelton@enter.net> wrote:
> > If you take the microsoft windows source code and compile it yourself
> > believe me you will get sued if you ship the resulting binaries and you
> > will lose in court.

"misappropriation of trade secrets" as well as copyright infringement

> But that's because it is *WINDOWS*, which, unless specifically granted to you,
> does not include a transfer of the right to distribute in *ANY* form. Every
> PC manufacturer that wants to distribute Windows on new machines they produce
> *MUST* sign an agreement with M$. As I have never seen any of those
> agreements I cannot state what the terms are and whether they are different
> for each company holding such a license.

contract in personam, creating causes of action for breach of contract
(for which remedies of specific performance are available) and
strengthening the case for misappropriation of trade secrets

> And unless you've signed a licensing agreement over the source code to
> Windows, you're more than likely to have another lawsuit on your hands for
> possessing it.

Not for possessing it.  For acquiring it unlawfully, and for doing
things with it that violate M$ copyright.

> <snip>
> > I would also note that the FSF makes no claim about dynamic v static
> > linking, merely about derivative works - which is the boundary the law is
> > interested in. Indeed the GPLv2 was written in the days where dynamic
> > linking was quite novel which is one reason the LGPL talks about

The FSF makes lots of such claims, all the time, and Eben Moglen uses
them to finesse his letter-of-opinion / affidavit racket, along with
the fork/exec fetish.  Fluendo.  Vidomi.  XCode.  Tornado.  NeXT.
Progress Software.

> > "For example, if you distribute copies of the library, whether gratis
> >  or for a fee, you must give the recipients all the rights that we gave
> >  you.  You must make sure that they, too, receive or can get the source
> >  code.  If you link a program with the library, you must provide
> >  complete object files to the recipients so that they can relink them
> >  with the library, after making changes to the library and recompiling
> >  it.  And you must show them these terms so they know their rights."
>
> Eh? Complete *object* files so that after making changes and recompiling they
> can relink it? Umm... I don't know about you, but that makes me laugh. What
> is the purpose of providing "Complete Object Files" to everyone if they are
> just going to recompile and relink the library?

Complete object files for the rest of the non-GPL application.  This
applies principally to static linking.  It also makes it much easier
to reverse engineer the application, because unless the person
jockeying the linker is really, really good, all of the interfaces
between the application components are visible with nm and objdump,
and you can use tools like ltrace to watch the calling sequences
between modules.  Selective symbol stripping and obfuscation on
partially linked binaries takes skill.

> > Flex is more complex because the resulting binary contains both compiled
> > work of yours and a support library of FSF owned code (-lfl).

No, flex is simpler because libfl is obviously a separate work of
authorship with a stable external interface, and the application that
links against it is not a derivative work of any of the creative
expression inside libfl.

> Copyright *doesn't* extend to compiled code. It cannot, because compiled code
> is a machine generated translation. A machine generated translation isn't the
> product of a creative process. And you can also provide all the routines
> normally provided by the support library. This means that the support library
> is *NOT* a necessary part of the system.

That's rubbish.  Copyright in compiled code is very nearly identical
to copyright in the source code from which it was generated; see
references in Lexmark, especially the seminal Altai case.  Copyright
in silicon is _not_ identical to copyright in the RTL from which it
was synthesized -- the term of protection for a "mask work" is limited
to 10 years -- 2 if it's not registered properly.  This prima facie
bizarre situation reflects the difference in national origin and
lobbying power between software and hardware makers, as well as the
greater difficulty of extracting the theory of operation of a complex
chip using an electron microscope.  The chip design oligopoly is bound
by a web of contractual covenants not to do this anyway, and they like
being able to snap up key people from upstart maverick companies and
rip off their designs without pesky legal interference.

> > The non
> > computing analogy here is the difference between using a paint program to
> > create a work, and using a paint program to create a work but also
> > including other artwork (eg clipart).

Not really.  Using stock images to illustrate a manuscript requires
license to copy and distribute them but rarely, if ever, creates a
derivative work.

> Yes, but in both cases the result is *CLEARLY* the result of a creative
> process, and said clipart, unless it is in the form of an entirely machine
> generated image, is a separate work (and one resulting from a creative
> process) that you are using under license. (Unless said clipart was released
> into the public domain)

Right.

> > The same is true of the GCC compiler
> > as it merges your work with supporting library helper code modules which
> > are themselves creative works.

Still nonsense.  It does not "merge your work" in any sense relevant
to copyright.  Insofar as any text has been copied from the library or
its sample applications to your application code, it is overwhelmingly
likely (IANAL, TINLA) to be considered part of the "scenes a faire" of
making engineering use of the library.  (This is, ironically, part of
the "doctrine of merger" of ideas and expression, which always, always
works against the party claiming copyright infringement.)  Insofar as
you have glued together program and library to form an engineering
product, it is again overwhelmingly likely to be considered a mere
"parcel of goods" and require authority from the library copyright
holder to copy and distribute.  See, however, Mirage Editions v.
Albuquerque A.R.T. -- you had better be relying on a valid license,
not "fair use", if your work may interfere with the library copyright
holder's ability to monetize his.

> Again you are confusing a mechanical translation process with a creative
> process. But it doesn't matter, in this case. The binary form of a program
> *technically* falls under the copyright on the source code - a mechanical
> process that translates a copyrighted work into another form *cannot* remove
> the original copyright.

Right.

> But said modules have clearly defined and limited purposes.

Doesn't matter to copyright.  Copyright is not about engineering use or purpose.

> > Clearly you could replace those helper
> > modules with your own work and the result would be different.

Not for any copyright purpose.  They are separate works of authorship,
whether or not the same entity holds copyright on them.

> Yes.  And you've noted that yes, they can be replaced. Which means that they
> are also not a necessary part of the system.

Irrelevant to copyright.  Copyright is not about engineering
necessity.  Some defenses against a claim of copyright infringement
are (again, see Lexmark), but you don't need any of those defenses --
you are operating under the terms of a valid contract containing
license from the copyright holder.

> Claiming that any library (that can be replaced), either dynamically or
> statically linked to a program, is a requirement isn't smart. That also means
> that claiming a program that uses those libraries is a derivative work is
> bull.

Whether it is a derivative work is determined, solely and exclusively,
by whether it "recasts, transforms, or adapts" the creative expression
in the original -- whether or not it could have been created in its
present form without reference to the original.  See Lotus v. Borland.

> Further, if such a library or module has an interface that must be accessed in
> one specific way, then said interface cannot be copyright. (As has been
> pointed out to me several times in other threads on LKML)

"scenes a faire"

> > A better example for your case might be indent where the program
> > processes your work mechanically and produces an output that doesn't
> > contain any other creative works, or most of intltools which merges
> > translations mechanically. (the merge code is sometimes a little creative
> > but thats in the sense of being a nuisance not in the legal sense of
> > creative work)

These are indeed obvious; but no more obvious (in terms of the
mountain of case law) than flex or bison or readline.

> True. But in those cases there isn't the gray area that exists surrounding
> claims of a Flex generated scanner or a Bison generated parser being
> derivative works of either program.

Ain't gray.  It's the blinding, shining, white of spotless innocence.
You just haven't awakened completely from Eben Moglen's opium dream in
which white is black and the question is who's to be master, that's
all.

Cheers,
- Michael
