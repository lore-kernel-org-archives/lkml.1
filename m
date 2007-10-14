Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXJNLMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXJNLMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 07:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXJNLMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 07:12:41 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4853 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbXJNLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 07:12:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Date: Sun, 14 Oct 2007 13:12:25 +0200
User-Agent: KMail/1.9.7
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
References: <1192053794.15601.47.camel@gaivota> <20071010163625.b4b438ec.akpm@linux-foundation.org> <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
In-Reply-To: <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141312.26069.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 12:40:35 Markus Rechberger wrote:
> On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 11 Oct 2007 01:00:39 +0200
> > "Markus Rechberger" <mrechberger@gmail.com> wrote:
> >
> > Please don't send 900 line emails to which you have added only an
> > additional paragraph.
> >
> > > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> > >
> > > not accepted
> >
> > Until your attempt to get the userspace-driver work merged into the
> > kernel is successful (and from my reading of last month's
> > discussion it is nowhere near that), we should continue to maintain
> > the present driver.
> >
> > If you choose to not participate in that maintenance then others
> > will need to do their best in this regard.
> >
> > What we should not and will not do is to permit the current driver
> > to be held hostage to your attempt to force a controversial and
> > apparently unwelcome change into the tree.
>
> (please read through it ... )
>
> I didn't comment this one yet, so here a few further details. Note
> I'm not looking forward to annoy other developers I want to get that
> driver completly done.
>
> some background information on the further userspace idea:
> http://lists.freebsd.org/pipermail/freebsd-multimedia/2007-September/
>007497.html
>
> short overview, this driver has moved a massive amount to userspace:
> libtuner/
>         (libtuner.so) User-mode drivers for tuners, demodulators, and
> anything else that constitutes the "frontend".
>
> So how is this related to my project? This project can reuse all the
> userspace demods and tuner code which I have as they are including
> the floating point stuff.
>
> I had a discussion with Hans Verkuil (the IVTV maintainer) about my
> requirements and his answer was:
>
> 2:06 <hverkuil> - However, it is a fact that the relationship between
> you and the linux(tv) community are strained to put it mildly. I
> remain convinced that none of this has any technical basis but has
> all to do with personality conflicts. To be honest, right now I think
> there is no solution in sight. This is a valid reason to consider
> stopping.

Um, please ask next time when you want to quote from a private 
discussion.

To put it in perspective: I meant here that stopping the em28xx 
development using GPL is a consideration, not to take em28xx hostage. 
My first point in that same discussion was this:

"hverkuil: - It is pointless to worry about what others might do with 
your GPL code. Anyone can take it at any time and who knows, they might 
succeed. Then again, they might not. In any case, it shouldn't be a 
reason to consider stopping."

The only people you are hurting by taking em28xx offline are the 
end-users and yourself, I'm sorry to say.

Regards,

	Hans

> the reason why I take the em28xx as hostage is, well I started with
> it and I work with that company and I don't see a way how to
> implement the latest devices without terrible hacks (and there are
> around 60 devices supported only by the current available driver and
> it will double that number since customers will change several chips
> on those boards)
>
> Due those "personal" conflicts I don't see how I can discuss it with
> the linuxtv people who are against me, I even tried to discuss this
> with Mauro (who never worked with a company in that area actually so
> he doesn't seem to understand what I try to achive, at least I
> haven't heard any technical reason why that work should be bad).
>
> Without any help to take aside those personal issues I don't see how
> this can be solved.
> I pulled all my linux opensource projects offline till this is
> cleared up I don't want to do 90% of all work and people taking over
> my project doing 10% of hacks for getting some credits. The long time
> support is not related to linux only.
>
> As for the BSD project, the developers who work with kaffeine and
> xine are fine with another interface which can support those BSD
> drivers, as for the linux world it would mean an easy abstraction to
> use i2c-dev with the existing userspace drivers without having to
> change a single line in those drivers.
>
> sorry for bothering but it seriously cost alot of my private time as
> well, Markus
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer


