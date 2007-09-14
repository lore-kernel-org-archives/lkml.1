Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXINRrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXINRrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbXINRq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:46:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:34805 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXINRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=utKKx9Ddyi6BmWE+Or3fqCdKNRZ64RXFr298FxFrfpd89vFVF4UhEJAOwcuALffMck+7DtwSaH1DEvJOU0JA59xk5B4X05ZK3LqZgyJ0jUxmjGZePZmZSnJtmBQyps1/jeB2OCuYh9y0H/cOh6HzWYk0FcKib+eEWd1KUv+SEuI=
Message-ID: <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
Date: Fri, 14 Sep 2007 19:46:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Johannes Stezenbach" <js@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>, mschimek@gmx.at
In-Reply-To: <1189791161.2363.8.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <1189791161.2363.8.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Markus,
>
> > >
> > > Maybe you still don't realize how tiresome it is to talk to you.
> > > What you present as "linuxtv people block my contributions" is
> > > IMHO "linuxtv people got fed up talking to you". Because when
> > > people disagree with you, you keep rambling on and on instead
> > > of just accepting it. See, working with an Open source community
> > > requires that you don't piss everyone off, but instead find
> > > ways to _motivate_ them to help you fix the problems which
> > > prevent your code from being merged. When people are doing
> > > software development _for fun_, then it should be a _pleasure_
> > > for them to work with you, and not a pain in the ass.
> > >
> >
> > Johannes,
> >
> > people do contribute to the em28xx project.
> > If noone keeps finding solutions for requirements I will of course
> > go on to find my own way.
> > Although upcoming and even the current requirements are not met
> > by the existing API.
> > It's worth nothing to merge what's available now since I'm not even
> > ok with how several issues are solved with the driver itself at the
> > moment.
> > I'm going forward step by step with it now.
> >
> > there's also an active and even problem solving oriented ML available:
> > http://mcentral.de/pipermail/em28xx/
> >
> > Also if you look at the mercurial code you'll see several people
> > contributing to that project.
>
> Solutions for your requirements can be reachable via a kernelspace
> solution:
>
> - The hybrid tuner support, that where your requirement, when all those
> discussions started, were already added to the subsystem. So now, an
> hybrid tuner can be accessed by both DVB and V4L devices;
>

It's far more complex as the thing which is implemented there.
The only thing that has been implemented is that one moduleformat
can be loaded by the v4l and by the dvb framework nothing else at the
moment. I told you at the kernel summit about that and I think you
knew about that before.

Just to quote some text:
"Right now, a separate instance of the driver is used for analog /
digital tuning.  In order to use a single instance, we will have to
store a pointer to the dvb_frontend structure on the bridge level, but
there are various other prerequisites that must be dealt with before we
get to that point.

We _will_ get there though, eventually."

> - Audio standard selection is already possible via S_STD (it is already
> working for a few standards, like NTSC/M JP and NTSC/M KR). Maybe more
> standards should be needed, but hey, we still have 34 bits available at
> std mask.
>

Let me quote some text where you've been in CC and which didn't get
far enough to get a solution implemented.

(Michael Schimek)

"> xc3028_BG_PAL_A2_A.i2c FW_78 > B/G PAL A2
>   Group delay: See RecITU-R BT.470-6 p.21 Response "A"
> xc3028_BG_PAL_A2_A_MTS.i2c FW_78_MTS B/G PAL A2 ZWEITON
> xc3028_BG_PAL_A2_B.i2c FW_78 B/G PAL A2
>   Group delay: See RecITU-R BT.470-6 p.21 Response "B"
> xc3028_BG_PAL_A2_B_MTS.i2c FW_78_MTS B/G PAL A2 ZWEITON

> xc3028_BG_PAL_NICAM_A.i2c FW_78 B/G PAL NICAM
>   Group delay: See RecITU-R BT.470-6 p.21 Response "A"
> xc3028_BG_PAL_NICAM_A_MTS.i2c FW_78_MTS B/G PAL FM
> xc3028_BG_PAL_NICAM_B.i2c FW_78 B/G PAL NICAM
>   Group delay: See RecITU-R BT.470-6 p.21 Response "B"
> xc3028_BG_PAL_NICAM_B_MTS.i2c FW_78_MTS B/G PAL FM

We cannot add new standards for each of these files because only six
bits are unassigned in the lower half of v4l2_std_id. It seems
unecessary too, please correct me if I'm wrong.

(Well the driver could define its own video standards for each of the
firmwares and put them into the upper 32 bits of v4l2_std_id, which were
set aside for this purpose. But adding standards to the API also has its
advantages. Maybe it's time to reserve bits 40-55 for future expansion.)

I suppose you choose firmwares with IF or baseband sound output
depending on the design of the card?"



> The point is: there's no technical need for userspace. This will just
> add userless complexity.
>
> However, you insist with your selfish idea that every other solution,
> except the one you're proposing are bogus. This is not the way Open
> Source development works. You should listen to people.
>

I pointed out a few requirements which didn't get commented at all, and
I explained why things where done in a particular way.

Markus
