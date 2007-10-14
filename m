Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbXJNL2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbXJNL2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 07:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXJNL2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 07:28:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:46935 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbXJNL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 07:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eFgOBI2kc+FxP2C2gW4ZwkJN8PvXtBvHmRBPxAcxTjOX9Ti2Bx/QEk8/0yiO1Cqpqs5vbdSm0GR0DoknZwaa2vwSjMII4uzJ/3hPFg4NoUE5VwDwE5A9YsbCRj3FXCDVZtaVm/FyczOQf3GQDTjeUVvSIw4sgMtCKQOdUwmKYIQ=
Message-ID: <d9def9db0710140428k3590a14bof2720f7797d191a2@mail.gmail.com>
Date: Sun, 14 Oct 2007 13:28:33 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: v4l-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
In-Reply-To: <200710141312.26069.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <20071010163625.b4b438ec.akpm@linux-foundation.org>
	 <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
	 <200710141312.26069.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sunday 14 October 2007 12:40:35 Markus Rechberger wrote:
> > On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Thu, 11 Oct 2007 01:00:39 +0200
> > > "Markus Rechberger" <mrechberger@gmail.com> wrote:
> > >
> > > Please don't send 900 line emails to which you have added only an
> > > additional paragraph.
> > >
> > > > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > > > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > > > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> > > >
> > > > not accepted
> > >
> > > Until your attempt to get the userspace-driver work merged into the
> > > kernel is successful (and from my reading of last month's
> > > discussion it is nowhere near that), we should continue to maintain
> > > the present driver.
> > >
> > > If you choose to not participate in that maintenance then others
> > > will need to do their best in this regard.
> > >
> > > What we should not and will not do is to permit the current driver
> > > to be held hostage to your attempt to force a controversial and
> > > apparently unwelcome change into the tree.
> >
> > (please read through it ... )
> >
> > I didn't comment this one yet, so here a few further details. Note
> > I'm not looking forward to annoy other developers I want to get that
> > driver completly done.
> >
> > some background information on the further userspace idea:
> > http://lists.freebsd.org/pipermail/freebsd-multimedia/2007-September/
> >007497.html
> >
> > short overview, this driver has moved a massive amount to userspace:
> > libtuner/
> >         (libtuner.so) User-mode drivers for tuners, demodulators, and
> > anything else that constitutes the "frontend".
> >
> > So how is this related to my project? This project can reuse all the
> > userspace demods and tuner code which I have as they are including
> > the floating point stuff.
> >
> > I had a discussion with Hans Verkuil (the IVTV maintainer) about my
> > requirements and his answer was:
> >
> > 2:06 <hverkuil> - However, it is a fact that the relationship between
> > you and the linux(tv) community are strained to put it mildly. I
> > remain convinced that none of this has any technical basis but has
> > all to do with personality conflicts. To be honest, right now I think
> > there is no solution in sight. This is a valid reason to consider
> > stopping.
>
> Um, please ask next time when you want to quote from a private
> discussion.
>
> To put it in perspective: I meant here that stopping the em28xx
> development using GPL is a consideration, not to take em28xx hostage.
> My first point in that same discussion was this:
>
> "hverkuil: - It is pointless to worry about what others might do with
> your GPL code. Anyone can take it at any time and who knows, they might
> succeed. Then again, they might not. In any case, it shouldn't be a
> reason to consider stopping."
>
> The only people you are hurting by taking em28xx offline are the
> end-users and yourself, I'm sorry to say.
>

Yes, but continuing as before keeping it aside of everything also
hurts. I'm convinced that the roadmap which I aim at is fine there is
code which works and which is valueable for other projects.
What's the idea behind a forced separation? - One and the same code is
also used as it is in Windows drivers. If someone wants to commit his
free time in fixing or improving that work he's welcome to do so by
touching it once 3 targets are affected. The roadmap also includes OSX
which would be the 4th target.

What's the value of having those shareable components which have a
full implementation limited to linux which only supports a limited
subset of those features (and it requires a rewrite to get it fit into
the kernel, so those features will very likely get stripped off - this
is the current way how it's done)?

Markus
