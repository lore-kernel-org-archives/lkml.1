Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXD2A2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXD2A2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXD2A2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:28:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:12108 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbXD2A2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XT744wE4PywX0JtZaO+WPUcGny66PVwFWY2SCUQPNFS3ihYh9Oeb8TMt0E9/+SjUijdLVJhWkWt/qsle5EXct4xWnmj9KPOJZax4XkeJemghSirQPq2UPhMJa7R4ALTi/AmA3Xpe6a6MImYlViSB1PM0pZs60o6GAlDjOAXX+ww=
Message-ID: <d9def9db0704281728x55320e1eg6a1b841f9c5b2f0@mail.gmail.com>
Date: Sun, 29 Apr 2007 02:28:49 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21
Cc: "Adrian Bunk" <bunk@stusta.de>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	 <4630DB24.4030005@redhat.com>
	 <20070426201325.8a1ebda3.diegocg@gmail.com>
	 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	 <20070426224148.69b91b2e.diegocg@gmail.com>
	 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	 <20070428195320.GZ3468@stusta.de>
	 <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
	 <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
	 <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 29 Apr 2007, Markus Rechberger wrote:
> >
> > I totally disagree here, bugzilla is a very good tool. If someone is
> > too lazy to look at it it's his problem.
>
> You must be doing things very differently from a lot of other people if
> you think that's the case.
>

Well I'm behind the stuff I'm doing because I'm interested in it. And
if some bugs are introduced by my work or derived by my work I'd like
to get them cleaned up in the end.
If I see that someone reports bugs which doesn't really address my
work at all I just forward them to the subsystem/maintainer who's "in
charge" (if someone can say it that way for an open source project)

> > Kernel Janitors can pick out some bugs which aren't addressed by
> > anyone or got left behind.
>
> IF that happened, it would actually be great. That's what I'm arguing for.
> And it was basically what Adrian was doing!
>

I'm very sure that happens maybe it's just not visible to everyone
because there are so many open issues. (I just take myself as an
example here, I didn't do too much with other bugs but at least some
of my work closed 5 other bugs this year beside the bugreports I'm
getting directly)

> > How else should bugs get handled, sending them to the lkml?
>
> Actually, looking at Adrian's regression lists, yes. lkml worked better
> than bugzilla did. By at _least_ a factor of two.
>

Yes Adrian did a very good job with collecting every bugreport and
sending the mails to all corresponding subsystems.

> > I'm 100% sure some bugreports will also get lost then, but on the lkml
> > they'll very likely remain lost whereas in the bugzilla they'll remain
> > as open.
>
> What's the difference between bugzilla and lkml.org? Both have search
> buttons. Both archive the old stuff. Both can be pointed to.
>

Both have search buttons yes, but the lkml doesn't leave an unread
mail open ontop of the lkml as bugzilla does if you look for open bugs
in a subsystem.

> > what are your suggestions to improve a bugreporting tool, I'm very
> > sure that many people, especially people who want to get into existing
> > projects here, would love to contribute.
>
> I don't know what the perfect setup is, but I do know that bugzilla is
> very close to be totally useless for the top-level maintainers.
>
> Try to think like a person who doesn't maintain *one* specific file in the
> kernel, but who can actually make a good judgement about a lot of things,
> or at least funnel a problem report to the right person?
>
> And now, imagine that that person is also fairly busy (exactly *because*
> he's not looking at a single file, he may be maintaining a huge subsystem
> that has multiple submaintainers etc).
>
> And ask yourself whether bugzilla really helps.
>

bugzilla keeps the bugs open at least, at the lkml I use to skip days sometimes.
Many people who consider themself as maintainer of a subsystem are
assigned to a subsection on bugzilla, if it really doesn't work out we
have to change the corresponding maintainer.
If that maintainer doesn't know where to go with that bugreport he can
easily send it to the lkml and some people will recognize the
sender/email and pay extra attention to it (that's just how I think
about it)

> > I'd say this is a personal opinion, some people will get along with it
> > and some of them will not...
>
> I think bugzilla really only works for very "directed" issues. If you
> already know exactly which driver is affected (which is often wrong
> anyway: some of the bugs that were due timer breakage got blamed as disk
> hangs!) it's almost totally useless.
>
> And yes, maybe that's why you have a much higher opinion of bugzilla than
> I do. To _me_ bugzilla is a total mess. There's absolutely _zero_ useful
> information there. And I'm pretty certain that is true of a *lot* of other
> people too. But if you have a small project, or you maintain a very
> specific (and clearly delineated) part of a big project, bugzilla probably
> looks a lot more palatable.

well are there any bugs that cannot be forwarded/directed to a
corresponding maintainer?
Maybe I don't see something here, can you point me out to a bugreport
which cannot be handled at all?
As a reference I'll take following bugreport:
http://thread.gmane.org/gmane.linux.kernel/521185

the bug doesn't even mention what device is affected, asking for
further detailed information (dmesg) shows up what's left at least..
(in the meanwhile the bug even got solved)

Markus
