Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbXJNKkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbXJNKkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbXJNKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:40:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:59163 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXJNKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UZewtHvhjmf6aUa/3vPLXOJr9+CJGoxgBsmi8yPiUiOYIwe1gmQc2VRyRY1ES8HnasHaNoGD1Q/B95sRoKQlTjmN/pzc115Y2N92iZHCSRitft1VSG/i/qQSZq42TRFF9saPb66wDJyAEaRzG3CEp/WICaiUBlzIsYLfqlHBMoQ=
Message-ID: <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
Date: Sun, 14 Oct 2007 12:40:35 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071010163625.b4b438ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <20071010163625.b4b438ec.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2007 01:00:39 +0200
> "Markus Rechberger" <mrechberger@gmail.com> wrote:
>
> Please don't send 900 line emails to which you have added only an additional
> paragraph.
>
> > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> >
> > not accepted
>
> Until your attempt to get the userspace-driver work merged into the kernel
> is successful (and from my reading of last month's discussion it is nowhere
> near that), we should continue to maintain the present driver.
>
> If you choose to not participate in that maintenance then others will need
> to do their best in this regard.
>
> What we should not and will not do is to permit the current driver to be
> held hostage to your attempt to force a controversial and apparently
> unwelcome change into the tree.
>

(please read through it ... )

I didn't comment this one yet, so here a few further details. Note I'm
not looking forward to annoy other developers I want to get that
driver completly done.

some background information on the further userspace idea:
http://lists.freebsd.org/pipermail/freebsd-multimedia/2007-September/007497.html

short overview, this driver has moved a massive amount to userspace:
libtuner/
        (libtuner.so) User-mode drivers for tuners, demodulators, and anything
else that constitutes the "frontend".

So how is this related to my project? This project can reuse all the
userspace demods and tuner code which I have as they are including the
floating point stuff.

I had a discussion with Hans Verkuil (the IVTV maintainer) about my
requirements and his answer was:

2:06 <hverkuil> - However, it is a fact that the relationship between
you and the linux(tv) community are strained to put it mildly. I
remain convinced that none of this has any technical basis but has all
to do with personality conflicts. To be honest, right now I think
there is no solution in sight. This is a valid reason to consider
stopping.

the reason why I take the em28xx as hostage is, well I started with it
and I work with that company and I don't see a way how to implement
the latest devices without terrible hacks (and there are around 60
devices supported only by the current available driver and it will
double that number since customers will change several chips on those
boards)

Due those "personal" conflicts I don't see how I can discuss it with
the linuxtv people who are against me, I even tried to discuss this
with Mauro (who never worked with a company in that area actually so
he doesn't seem to understand what I try to achive, at least I haven't
heard any technical reason why that work should be bad).

Without any help to take aside those personal issues I don't see how
this can be solved.
I pulled all my linux opensource projects offline till this is cleared
up I don't want to do 90% of all work and people taking over my
project doing 10% of hacks for getting some credits. The long time
support is not related to linux only.

As for the BSD project, the developers who work with kaffeine and xine
are fine with another interface which can support those BSD drivers,
as for the linux world it would mean an easy abstraction to use
i2c-dev with the existing userspace drivers without having to change a
single line in those drivers.

sorry for bothering but it seriously cost alot of my private time as well,
Markus
