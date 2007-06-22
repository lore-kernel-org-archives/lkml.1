Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbXFVArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbXFVArw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXFVArn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:47:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXFVArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:47:42 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070621180029.GR21478@ftp.linux.org.uk>
	<orhcp1jc8o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070621230404.GS21478@ftp.linux.org.uk>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 21:47:11 -0300
In-Reply-To: <20070621230404.GS21478@ftp.linux.org.uk> (Al Viro's message of "Fri\, 22 Jun 2007 00\:04\:05 +0100")
Message-ID: <orabusizn4.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:

> On Thu, Jun 21, 2007 at 05:15:03PM -0300, Alexandre Oliva wrote:
>> Anyone who's not happy about it can still take that portion out,
>> unless you accept changes that make this nearly impossible, which I
>> suppose you wouldn't given how strongly you feel about this.

> Oh, right.  "Anyone who doesn't like proprietary code in the tree
> can just remove it, what's the big deal?" analog.  Sorry, doesn't work.

Well, you do have proprietary code in Linux, and it's definitely not
easy to take it all out, so, point.

However, the difference that you appear to be missing is that when you
get code under GPLv3, or under this hypothetical combination of GPLv2
and GPLv3 code, everyone who received the combination could still do
everything the GPL says they could do: run the code for any purpose,
study it, adapt it, modify it and distribute it, with or without
modifications, under the same conditions, to the recipient, without
imposing any further restrictions.

The only thing that changes is that, for GPLv2, there's a possibility
that some licensees might be able to get away not permitting other
licensees to do the things the license you chose permits them to do,
using tricks that have been invented or that became matter of new laws
since GPLv2 was published.

But this doesn't mean GPLv2 unambiguously permits this behavior; that
you want it to doesn't make it so for all contributors.  Just like you
have the right to veto any additional permissions on Linux, so can
other contributors.  And unambiguous permission to tivoize is an
additional permission, just like permission to combine code with GPLv3
is an additional permission.

Heck, even the requirement to provide source code under GPLv1 and
GPLv2 is a clarification along the same lines of the new provisions of
GPLv3.  Denying access to the source code is a restriction on the
exercise of the rights granted by the license.  So it's implied.  But
since some people might not see it that way, it's spelled out in full.
Same deal with patents in GPLv2, and all the other new provisions with
GPLv3.  What makes them incompatible is not that they impose new
restrictions (they really don't), it's that they remove any doubts
about that.


>> I can see that one-way cooperation could be perceived as unfair, even
>> if permissions granted by GPLv3 are all granted by GPLv2 as well.

> ... but not the other way round.  So in effect we get a change of kernel
> license, GPLv3 people *do* *not* get any license changes on their projects.
> And you are saying that it's not one-way?

GPLv3 people *do* get license changes too.  This can be accomplished
with additional permissions on both licenses with the current GPLv3
draft.  I'm proposing that this backward compatibility could be a
built-in feature of GPLv3.

As to whether this has any effects on GPLv3 projects, it does.  It
weakens the legal defenses for the entire project, in as much as the
wholes in GPLv2 might still be exploited.

>> > ... except for that pesky "no added restrictions" part, but hey, who
>> > cares?

>> But see, nobody would be adding restrictions to *your* code.

> What you are saying is "but your code will be still
> available under GPLv2".

No, I'm saying far more than this obvious conclusion, on which you
apparently stopped thinking.

I'm saying the project that uses it won't get as strong legal defenses
as it would get if it were under GPLv3.  So, yes, both sides sacrifice
some of their stances in order to enable mutual cooperation.

Sure, if you don't want to do that, that's your call.  But don't try
to frame it as if there was something wrong or unfair about it.

> So it will be if e.g. SCO pulls it into proprietary codebase.

Except that then I won't be able to enjoy any of the rights that you
meant me to enjoy as to the code that SCO distributes.

Whereas with combination of GPLv2 with GPLv3, every licensee still
gets all of the same freedoms respected.  The difference is only as to
how much they can deny other licensees the freedoms you meant them to
get.

And if someone cares about using your code to deny other licensees
freedoms, they still can.  Depending on how much you intermingled your
code with code that doesn't want to permit this, it will be more or
less difficult to do, but it can be done.

> The first change in v3 project affecting both imported v2 code and
> native v3 one will create a big problem.

Why?  The licenses permit combination/linking, each portion remains
under the same license as their authors meant.

>> > ... because it's For The Benefit Of User Freedoms!!!

>> It is either way.  Do you deny that tivoization also benefits one
>> user/licensee?  And in detriment of others, while at that?

> You know, we have another wanker here starting another thread from
> hell - one about allowing stable driver ABI, to make the life of
> proprietary modules more convenient.

And it's indeed the same issue: placing the interests of a few
licensees over others'.

That you decide differently in the two cases just goes to show how
consistent your opinion is.

>> > No.  Permission denied.
>> 
>> Your opinion is duly noted.  Thanks.

> It's not an opinion.  It's a lack of permission to distribute GPLv2 code
> under conditions violating its license.

Your whatever you want to call it is duly noted.

> Nice spin.  "Your license doesn't allow to put your code under the
> license we want, you are mean and uncooperative!  Giiiimmeeee!!!  Or
> be condemned as a Bad Person and an Enemy of Freedom"

It's not nice to be on the other end of such silly accusations, is it?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
