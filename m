Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXCIWSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXCIWSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXCIWSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:18:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:15234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbXCIWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UoZ38WSLe100QV0mY2FeBT2A5E+Vo72KbyJzpWNx12mX4tsmmq/PSP82i7SpHnQMeWBU336Kydg3QqgAsEqzz37M/HNHb7VrdFw/tG15rDsgHTJpawJQ3r5nnUcAKW4ZMRm91O8qDrPZ6boMUnFHkqkHDW+M8lj7GE7BpQoTVQc=
Message-ID: <48f7fe350703091418p133a955ar8bef47db33a42e3f@mail.gmail.com>
Date: Fri, 9 Mar 2007 17:18:31 -0500
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Cc: "William Lee Irwin III" <wli@holomorphy.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200703092343.46276.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703091625.55361.a1426z@gawab.com>
	 <20070309135751.GE2986@holomorphy.com>
	 <200703092343.46276.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from what I understood, there is a performance loss in plugsched
schedulers because they have to share code....

even if pluggable schedulers is not a viable option, being able to
choose which one was built into the kernel would be easy (only takes a
few ifdefs), i too think competition would be good

On 3/9/07, Al Boldi <a1426z@gawab.com> wrote:
> William Lee Irwin III wrote:
> > William Lee Irwin III wrote:
> > >> I consider policy issues to be hopeless political quagmires and
> > >> therefore stick to mechanism. So even though I may have started the
> > >> code in question, I have little or nothing to say about that sort of
> > >> use for it.
> > >> There's my longwinded excuse for having originated that tidbit of code.
> >
> > On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> > > I've no idea what both of you are talking about.
> >
> > The short translation of my message for you is "Linus, please don't
> > LART me too hard."
>
> Right.
>
> > On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> > > How can giving people the freedom of choice be in any way
> > > counter-productive?
> >
> > This sort of concern is too subjective for me to have an opinion on it.
>
> How diplomatic.
>
> > My preferred sphere of operation is the Manichean domain of faster vs.
> > slower, functionality vs. non-functionality, and the like. For me, such
> > design concerns are like the need for a kernel to format pagetables so
> > the x86 MMU decodes what was intended, or for a compiler to emit valid
> > assembly instructions, or for a programmer to write C the compiler
> > won't reject with parse errors.
>
> Sure, but I think, even from a technical point of view, competition is a good
> thing to have.  Pluggable schedulers give us this kind of competition, that
> forces each scheduler to refine or become obsolete.  Think evolution.
>
> > If Linus, akpm, et al object to the
> > design, then invalid output was produced. Please refer to Linus, akpm,
> > et al for these sorts of design concerns.
>
> Point taken.
>
> Linus Torvalds wrote:
> > And hey, you can try to prove me wrong. Code talks. So far, nobody has
> > really ever come close.
> >
> > So go and code it up, and show the end result. So far, nobody who actually
> > *does* CPU schedulers have really wanted to do it, because they all want
> > to muck around with their own private versions of the data structures.
>
> What about PlugSched?
>
>
> Thanks!
>
> --
> Al
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
