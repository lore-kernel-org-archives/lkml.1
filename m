Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXINRdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXINRdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXINRc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:32:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35700 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbXINRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:32:56 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       Manu Abraham <abraham.manu@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 14:32:41 -0300
Message-Id: <1189791161.2363.8.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

> >
> > Maybe you still don't realize how tiresome it is to talk to you.
> > What you present as "linuxtv people block my contributions" is
> > IMHO "linuxtv people got fed up talking to you". Because when
> > people disagree with you, you keep rambling on and on instead
> > of just accepting it. See, working with an Open source community
> > requires that you don't piss everyone off, but instead find
> > ways to _motivate_ them to help you fix the problems which
> > prevent your code from being merged. When people are doing
> > software development _for fun_, then it should be a _pleasure_
> > for them to work with you, and not a pain in the ass.
> >
> 
> Johannes,
> 
> people do contribute to the em28xx project.
> If noone keeps finding solutions for requirements I will of course
> go on to find my own way.
> Although upcoming and even the current requirements are not met
> by the existing API.
> It's worth nothing to merge what's available now since I'm not even
> ok with how several issues are solved with the driver itself at the
> moment.
> I'm going forward step by step with it now.
> 
> there's also an active and even problem solving oriented ML available:
> http://mcentral.de/pipermail/em28xx/
> 
> Also if you look at the mercurial code you'll see several people
> contributing to that project.

Solutions for your requirements can be reachable via a kernelspace
solution:

- The hybrid tuner support, that where your requirement, when all those
discussions started, were already added to the subsystem. So now, an
hybrid tuner can be accessed by both DVB and V4L devices;

- Audio standard selection is already possible via S_STD (it is already
working for a few standards, like NTSC/M JP and NTSC/M KR). Maybe more
standards should be needed, but hey, we still have 34 bits available at
std mask.

The point is: there's no technical need for userspace. This will just
add userless complexity.

However, you insist with your selfish idea that every other solution,
except the one you're proposing are bogus. This is not the way Open
Source development works. You should listen to people.


Cheers,
Mauro

