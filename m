Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbXIOM7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbXIOM7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXIOM7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:59:39 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:36315 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbXIOM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NKIn6va845I6/7nBWU1LzoyWgH0HEq2sM90OT6cSi0UIzdUTRRsSKyaLWAKMickUumak3SiOJEcnH37wIU2ESe2kBJgIfVRbrpG8Y99koe8Hyhg99fcf2nVo5Hlk0i1rYBVSDcDhYb+X2Zn9XuId9qFJlaHtVNM+95vknVMa0po=
Message-ID: <d9def9db0709150559y3cfb9916oc9d5e42b5e26ddc0@mail.gmail.com>
Date: Sat, 15 Sep 2007 14:59:35 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Johannes Stezenbach" <js@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <1189825748.5359.77.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913131353.GB26972@linuxtv.org>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
	 <1189825748.5359.77.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > The main discussion in this thread was about drivers in userspace
> > are bad because the API will allow binary drivers.
>
> No. The focus is that userspace API is not needed at all, and the
> community believe that this is a regression from all efforts that are
> being done by the community to have good quality OSS software.
>

please have a look at:
http://mcentral.de/wiki/index.php/Bugtracker


> > The guy
> > who works for Hauppauge (again I also have good contacts
> > at Hauppauge Europe) writes it's bad - for no technical reason.
>
> Please stop with personal attacks.
>

This is no personal attack.

> > I (again) don't intend to
> > release binary drivers. (also keep in mind that ubuntu takes
> > everything which makes things work - this matters to the enduser)
>
> Markus, you are thinking that all the community are fool?

You're using the word "community" in a quite abstract way here.
Please document how the linuxtv community behaves behind the
lines, and I would even like that those people who discussed several
things would start to write about their other personal issues with
that project which I'm not part of.

> You used to
> state on your website that your intention were to release binary-only
> xc5000 drivers.

people talk alot, in the end only the result counts. So if you've seen
any binary driver from my side point out to it. To be honest
I think if I would have gone the same way as Avermedia from the
beginning on to release binary drivers it would have saved months
of development and the main distros could already have _full_
support for all the features.
The driver as it is now is not perfect either it requires quite some
more work to get all features work flawlessly around the globe for
all the users.

> So, please stop with childish and assume what you've said.
>
> > Mauro is copying the logic of my code and writes I told him I'm ok with
> > taking my code without just adding a single line of how his driver
> > got developed. (I still wonder why he skipped some significant parts
> > of the driver .. because he used the existing one as logic template)
> >
> >
> http://linuxtv.org/hg/~mchehab/tm6000-new/log/14352ab89146/linux/drivers/media/video/tuner-xc2028.c
>
> The basis for tuner-xc2028 driver is tea5767. The xc2028/xc3028 drivers
> is very simple:
>
> a) load the proper firmware;
> b) send one 32 bits command to select frequency + the frequency divider.
>

well people see if they compare the code what you took from the existing
driver.

> All the rest is the common logic of a tuner driver.
>
> If you take a look at my driver, you will see that the implementation is
> different, providing also those functionalities:
>
> - provides a sync during frequency setting, needed by tm6000;
> - has the logic to retrieve signal status;
> - part of the firmware need to be reload every time you change a freq
> (tm6000 driver needs it);
> - supports just the firmwares I've identified as being used by tm6000
> driver;
>
> The only thing I used is your usbreplay.pl, as properly stated at
> README.first (properly pointing to your site).
>
> Again, please stop with personal attacks. This leads to nowhere.
>

If you look at my current implementation and even the implementation
which I had a year ago many problems are solved there.
I don't mind if you don't want to use the userspace tuner API, it's not
a replacement for the inkernel version, it makes it just easy to
implement it.
The current and upcoming em28xx devices will use it, just to avoid
that I have to redo all the work hundret times for no real reason.

>
> >From my side, I've nacked your userspace tuner.
>
> However, I keep open to accept your kernelspace em28xx/xc3028 drivers,
> providing that they fits at the current V4L/DVB core.
>

I don't even want to use that existing driver in future (as I wrote earlier
already). The newer module will be a dropin userspace replacement for
what's available. I got around 70 devices work with it at the moment,
although I don't even want to reinvent the wheel so I'll take what I've
received from some companies. That way all I have to do is to use
the provided API of those silicon sample drivers.

> Changes at common APIs, and especially at Kernel to userspace API should
> be discussed with the community. If you accept this fact, you may also
> propose improvements at the APIs.
>

That for I wrote the RFCs which didn't get discussed properly and where
2 people of that "community" told me to use something which won't work
out at all.
And hey, why didn't those guys do what they told me to do in the end?
Because they wanted to do it by themself only. Although it's the base
of the driver without a proper base it just screams for more work in the
end.

> If, after all that were discussed, you're willing to do a serious work,
> please send us the patches for em28xx/xc3028 kernelspace drivers.
> Otherwise, I'll kindly ask you to take your own way and stop with those
> flamewars.
>

You don't have to use it if you don't like it, and I get around those
restrictions and I'm able to fix up and extend the features for the
upcoming devices without interfering your work.

Markus
