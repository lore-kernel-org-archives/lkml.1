Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXIOBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXIOBt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXIOBtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:49:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:19845 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbXIOBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=epqQcpEsBWnig960USktzYGUGFIIdFVTOBIR484rLm84QOZlOc868474RRJf/L/I8I4Py0L+K/3Ndu4Z2BDRKIF0tlA/NdhkX2GZgJfq4LChtf9HIOsoJVJcVU18SWa7rzjEegdI1f5WyuT8L3JcQxrjfzP7WgTXxHmN/mV9EDE=
Message-ID: <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
Date: Sat, 15 Sep 2007 03:49:44 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Steven Toth" <stoth@hauppauge.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20070914204343.GA9058@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913131353.GB26972@linuxtv.org> <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Fri, Sep 14, 2007, Markus Rechberger wrote:
> >
> > people do contribute to the em28xx project.
> ...
> > there's also an active and even problem solving oriented ML available:
> > http://mcentral.de/pipermail/em28xx/
> >
> > Also if you look at the mercurial code you'll see several people
> > contributing to that project.
>
> Of course, people who own such a device and want to use
> it with Linux have no choice but to work with you.
> And you do a good job for your users, you support them
> well and in return they contribute info and patches
> to support new devices.
>
> But the thing is that at mcentral.de you're the man at the top,

why is it mcentral.de at the moment? I started several discussions about
the whole topic. The thing which is in v4l-dvb on linuxtv does not satisfy
any requirements, also further additions will be hard to achieve with it.

> and your users will hardly disagree with you on core
> technical questions. (Well, admittedly I'm speculating
> here as I don't read your em28xx list.)
>

they can disagree, I even pointed out to design flaws lately when
some users posted bugreports.

> On for drivers/media/ OTOH you are just one developer among others,
> and some of them choose to disagree with you. Even worse,
> IIRC there wasn't even _a single_ other developer willing
> to ACK your offending patch.
>

the current patch isn't offending anymore, see it as a chance I'm
giving you the chance to acknowlidge what has been done now from
my side.
The main discussion in this thread was about drivers in userspace
are bad because the API will allow binary drivers. The guy
who works for Hauppauge (again I also have good contacts
at Hauppauge Europe) writes it's bad - for no technical reason.

If someone points out that it is bad (after reading the whole thread)
why don't we put X.org, bash, well everything into the kernel?
GPL is the saviour seems to be the saviour for some people in this
world, but in the end it's still if people want to go that way.
Much work has been done by other people before, my work
is also just an additional contribution and I (again) don't intend to
release binary drivers. (also keep in mind that ubuntu takes
everything which makes things work - this matters to the enduser)

Hey I can also write I can help you to get things right with some other
people, and I can financially support people by giving away
hardware and even specs for free in some cases. Who is able
to do that from the old crufted v4l/dvb guys?

Manu throws his drivers over the wall to the OSS community, although
I don't mind.
Mauro is copying the logic of my code and writes I told him I'm ok with
taking my code without just adding a single line of how his driver
got developed. (I still wonder why he skipped some significant parts
of the driver .. because he used the existing one as logic template)

http://linuxtv.org/hg/~mchehab/tm6000-new/log/14352ab89146/linux/drivers/media/video/tuner-xc2028.c
(not looking at the specific changeset but he copied the firmware
loading instructions without taking care about the copyright?)

> Now, doesn't _that_ get you thinking?
>

oh yes.

Markus
