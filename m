Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXBVGMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXBVGMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXBVGMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:12:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:3239 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbXBVGMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VzFk251v7OO62V8GWqPm9ci6F9EtzQpIUxCUF/RF37IThPjSWGZRUCqMBJnYfeQPicN3ZSD/56uQuOO5NEfi9rU3OsQhpK2JrCt9JHaX1EdPXHGX0Pg/JkecukneaFP2AAHYtxcD9AeUPv9uEEigGF0W4be8naP0jNgWCoAzA1E=
Message-ID: <f2b55d220702212212x49e0ac6ah85c929340627fcab@mail.gmail.com>
Date: Wed, 21 Feb 2007 22:12:34 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "D. Hazelton" <dhazelton@enter.net>
Subject: Re: GPL vs non-GPL device drivers
Cc: "David Lang" <david.lang@digitalinsight.com>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <200702212317.16262.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <200702212030.58317.dhazelton@enter.net>
	 <f2b55d220702211805h6df0b342o7676e37c7aa43bdd@mail.gmail.com>
	 <200702212317.16262.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, D. Hazelton <dhazelton@enter.net> wrote:
> Actually, on re-reading the GPL, I see exactly why they made that pair of
> exceptions. Where it's quite evident that a small to mid scale parsers that
> could have been written *without* the use of Bison is clearly a
> non-derivative work - Bison was not required, but was used as a mean of
> expediency. When you reach a large scale parser, such as one that meets all
> requirements to act as the parser for an ANSI C99 compiler, Bison stops being
> expedient - it'd likely take just as much time to hand craft the parser as it
> would to debug the Bison input. However, it makes maintaining the parser
> easier.

I repeat, that is not what "derivative work" means.  Do not try to
reason about the phrase "derivative work" without reference to its
definition in statute and its legal history in appellate decisions.
You will get it wrong every time.  You have not "recast, transformed,
or adapted" the _creative_expression_ in Bison or Flex in the course
of using it; so whether or not you have infringed the FSF's copyright,
you have NOT created a "derivative work".

If Bison and Flex were offered under the "bare" GPL, and you used them
to build a parser, and the FSF sued you for offering that parser to
other people on terms other than the GPL's, you don't defend by
claiming license under the GPL with regard to your parser.  You attack
the claim of "copying" itself by saying that the _creative_expression_
copied from Bison/Flex into your parser is "de minimis" under the
Altai Abstraction-Filtration-Comparison test.  You also point out
that, even if it weren't "de minimis", it's "fair use"; that's a
complex four-factor test, but the main thing is that you're not
interfering with the FSF's ability to monetize its copyright in
Bison/Flex.

If you have any sense, you will strenuously argue that the various
"special exceptions" for things like Bison/Flex and GNU Classpath are
_not_ part of the offer of contract contained in the GPL, any more
than the Preamble is.  They're declarations of intent on the part of
the copyright holder, and can be used to _estop_ the FSF from making
the copyright infringement claim against you in court in the first
place.  They promised you they wouldn't, not as part of the contract
terms, but as part of the inducement to form a contract with them by
acceptance through conduct.

> But the fact is that it's the small to medium scale parsers that have a lower
> ratio of original to GPL'd code that are at risk of being declared derivative
> works. All of this because the GPL contains the following text in section 0:
> "The act of running the Program is not restricted, and the output from the
> Program is covered only if its contents constitute a work based on the
> Program (independent of having been made by running the Program).
> Whether that is true depends on what the Program does."

I'm sorry, but that "ratio test" has nothing to do with whether
something is a derivative work or not.  It comes up mostly in
evaluating a "fair use" defense, and it's the ratio of the amount of
creative expression _copied_ to the amount of creative expression in
the _original_work_ that matters.  Just because you're writing a
49-volume encyclopedia does not give you the right to copy two thirds
of my one-page essay.  Those weasel-words about "depending on what the
Program does" are nonsense.  It depends on what _creative_expression_
from the Program winds up in the output.

> That clause, to me, seems specifically tailored to cover programs such as
> Bison and Flex. (and is the reason that I try to use Byacc and when I need
> to, write tokenizers by hand) This frankly stinks of attempts to cover all
> possible code. (I actually started studying Copyright law in my free time
> because I was wondering how legal the GPL was and was also puzzled by some
> major online entities actually complaining about it)

I've written tokenizers in at least six different languages to date,
including Fortran.  It's a pain in the butt.  The last thing I want to
be worrying about when I write a tokenizer is whether somebody else's
peanut butter is winding up in my chocolate.  So I will only use a
tool which, like bison and flex, is accompanied by a promise not to
claim that its output infringes the tool author's copyright or is
otherwise encumbered in any way.  M$ VC++ is actually more trustworthy
in that respect than G++.  If you don't believe (as I do) that it is
arrant nonsense to claim that the use of interface headers or linking
of any kind creates a derivative work, then you must believe that any
programs compiled with G++ can only be distributed under the terms of
the GPL.  libstdc++ is GPL, not LGPL.

> Since I tailor the license I apply to code I produce to meet the needs of the
> person or entity I am writing it for, I've never run into this.

That's kind of silly.  I use the GPL for my own from-scratch programs
all the time.  It's quite a sensible set of terms for source code
created as a side effect of a consulting project, when interpreted
according to real law instead of Eben Moglen's bullshit FAQ.  I don't
get paid to muck about with contract language, any more than I get
paid for turning knobs; I get paid for knowing which knob to turn.

> In truth, the
> LGPL is, IMHO, a piece of garbage. (as is the GPL - if you release code under
> the GPL you no longer have a legal right to it. Note the following text that
> appears in the GPL:
>
> "  We protect your rights with two steps: (1) copyright the software, and
> (2) offer you this license which gives you legal permission to copy,
> distribute and/or modify the software."

Er, that's the preamble, which has no legal force other than as a bit
of backstory and possibly grounds for estoppel against the FSF.  It's
also obviously an artifact of the original drafting of the GPL as a
license for FSF software alone.  No judge on earth would listen to a
claim that the FSF has obtained copyright on your work without
copyright assignment papers or a "work made for hire" paper trail.

> --IE: Once you release the code under the GPL, it becomes the *copyrighted*
> *property* of the FSF and you are just another person that the GPL is applied
> to. This means that if you later change your mind and decide to revoke the
> GPL on your code and replace it with say, the Larry Wall's "Artistic License"
> you are breaking the terms of the GPL and therefore lose all rights to modify
> and distribute your code.

Er, you're in the crack zone here.

> Will do. Now I think I'll get back to work on a private project that I've got
> in front of me. (When I release it the code will not be under *any* of the
> various GNU/FSF licenses - I'll probably wind up crafting one specifically
> for the project)

Personally, I don't see any reason not to use GPL or BSD (with or
without "obnoxious attribution clause") or MIT X11, other than the
ever-present danger of negligence suits due to incompetently crafted
"notice of no warranty" (it's smartest to make it clear that the only
person responsible for a failure to communicate the lack of warranty
is the person from whom the end user received the compiled program).
I don't lose sleep over that because I rarely, if ever, deliver a
binary to someone without a separate signed contract that makes the
warranty provisions crystal clear.  Avoid most other "open source"
licenses -- they frequently have booby-traps.  IANAL, TINLA.

Cheers,
- Michael
