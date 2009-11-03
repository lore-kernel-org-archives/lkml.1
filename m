Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZKCXyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZKCXyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZKCXyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:54:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:49986 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZKCXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:54:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Une0WvbGNYXk3mGk5IvMnIUYB4FY/SUBy/QUNFT0bP4Ywf2crg2+OGz+BLgVZjPKfD
         FQXWcII9B79t9ubVW12s/y37iR/RbqOtjAr0d1qyIanUkpLY7bYmPYunQw3tglp1cMlb
         ayTnPFX9jrTBlSiiftZFpwxm/dbZs+vAHmmog=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Wed, 4 Nov 2009 00:46:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <200911032334.40547.bzolnier@gmail.com> <14add3d10911031509l328e7674kb625b70250ff30fb@mail.gmail.com>
In-Reply-To: <14add3d10911031509l328e7674kb625b70250ff30fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911040046.54247.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 00:09:02 Gertjan van Wingerde wrote:
> On Tue, Nov 3, 2009 at 11:34 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Tuesday 03 November 2009 23:01:32 Ivo van Doorn wrote:
> >> > > > The following patch series (against wireless-next) addresses issues raised
> >> > > > during code review and subsequently rejected by rt2x00/wireless/networking
> >> > > > maintainers.
> >> > >
> >> > > Really stop reading only the half of emails, try reading it entirely (or at least don't
> >> > > stop at the second word in a sentence). It really starts the bug me to repeat
> >> > > myself over and over again because you refuse to read.
> >> > >
> >> > > Your comments during code review were ACCEPTED with the only remark that
> >> > > it shouldn't be done right here and now.
> >> >
> >> > Please stop this bullshit.  We have some standards for the upstream code
> >> > and by being maintainer you have to live up to this standards and make sure
> >> > that they are respected instead of watering them down yourself..
> >> >
> >> > You were not interested even in fixing the headers duplication (it turned
> >> > out debugging scripts needed only 25 lines of code to be able to work with
> >> > fixed headers -- 25 LOC in bash scripts used only for debugging instead
> >> > of 1800 LOC of kernel code).
> >>
> >> Yeah I know that. But like I said, I still needed to get around to do that,
> >> and I am very happy you were interested in fixing it.
> >
> > Lets make one thing clear: YOU SHOULD BE THE ONE FIXING IT.
> >
> > I'm not in slightest interested in wasting my time on such
> > things and educating some maintainers about basics.
> >
> > [ Code duplication is bad, mmm'okay?  Just say no, mmm'okay? ]
> >
> 
> Bart,
> 
> Are you really interested in working with us (the rt2x00 project) in
> getting the rt2800{pci,usb}
> drivers in a better shape, or do you just want to continue your
> ramblings on how bad you
> think the rt2x00 maintainers, wireless maintainer, and networking
> maintainer are in your view?
> 
> Just continuing these discussions doesn't help a bit as Ivo, John, and
> David said they disagreed
> with you on this topic.

I tried explain many times that it is not about what is in MAINTAINERS
file or what somebody says.

> If you just want to continue with a hostile take-over of the rt2800
> maintainership, then please
> let us know that, so that we stop spending time on useless

I fail to see why you see it as a hostile takeover.

I just did what should have been done in the first place (+ I'm going
to push drivers further in this direction in my tree) and I was always
pretty clear that once staging drivers become sufficiently cleaned up
I would start re-basing my efforts on in kernel drivers.

I will be glad to cooperate with you or anyone else from rt2x00 project.
However I will not spin in some stupid bureaucracy when I see that things
can be done more effectively.

> discussions, and let John Linville
> decide how he wants to handle this situation. It would be a shame of
> the good patches and work
> you did, but if that's the case, than that's it.

John can just pull my tree in right now since it is based on his tree
and it would be an immediate improvement over what its in his tree.

It is up to him, or Ivo can also pull my patches into his tree.

You can also decide to throw up my patches completely or re-do them
for some silly reasons.  I won't be making much noise about it since
I'll be already on some next patches..

> Otherwise, please focus on the technical contents of the patches and
> work with us to get
> these drivers in a better shape.

This is what I'm focused on, if you have any technical arguments w.r.t.
my patches I'm willing to listen and address them in sensible time
(if they are valid).  I would also be happy to work with people with any
patches that they are working on currently.

Thanks.
-- 
Bartlomiej Zolnierkiewicz
