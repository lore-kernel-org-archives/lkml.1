Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXIQJKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXIQJKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbXIQIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:46:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:23140 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbXIQIq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AbR1uhlEepF85UQgBwshqZ84uwn5YDD7nnxHBACt9Akduk5h3GJK/uFHiQ6bgiZd12M87Jx/hxwC0J33wnFCQRAWenXM71aHKVJgwpiowaUIyIv1wwRD1aSSSwLbKJjQddbg+8ZLywq0KO73TPX2FpLJ0siSE5O2HTvonuoUNNM=
Message-ID: <d9def9db0709170146u7827d43axf4f2dcf8bb80b352@mail.gmail.com>
Date: Mon, 17 Sep 2007 10:46:25 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Bernard Jungen" <bern8817@euphonynet.be>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <20070915165834.GA2054@euphonynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com>
	 <20070915131650.GA12531@linuxtv.org>
	 <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com>
	 <1189865082.5271.91.camel@gaivota>
	 <20070915165834.GA2054@euphonynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Bernard Jungen <bern8817@euphonynet.be> wrote:
> On Sat, Sep 15, 2007 at 11:04:42AM -0300, Mauro Carvalho Chehab wrote:
> > With respect to your kernel-userspace API for xc3028, you made something
> > that seemed to be a dream: there's a consensus: not a single developer
> > believed that this is the better way; nobody seems that this is the
> > better approach.
> >
> > So, or you are the only media developer with good sense in the face of
> > the Earth, or you're incapable of understand the obvious: you're wrong
> > with this approach. IMO, the answer is quite obvious.
>
> Yes, as a newbie observer on the v4l list, the answer is obvious to me,
> at last, and the reason is not entirely technical. I can't read so many
> bogus arguments on so few lines without reacting.
>
> Rephrasing Mauro:
>
> "Not a single developer out of a few SEEMS to believe that it is the BETTER
> approach, so since the FEW represent ALL media developers in the world, and
> since there is only ONE RIGHT way to do things, and since the GROUP is
> always RIGHT and always knows better than the individual, then YOU're WRONG
> and I'm right. Conform to the group and do as the group says, whatever the
> consequences!"
>
> Geeks are decidedly as prone as others to blindly accept travelling on the
> slippery road of herd mentality and "obvious" conclusions based on
> appearances. Is this OPEN source development or a dictatorship or what?
>
> So in the end Mauro will be right. And Markus will continue to develop and
> defend his stuff as HE sees fit. He knows his own work better than anyone
> else. It will be HIS way or nothing with his own stuff, it's his inalienable
> right.
>
> And don't be naive, if there's no solution more viable than Markus' one,
> then the latter will eventually be widely adopted somehow, sometime,
> whatever the amount of grumbling from the establishment. No
> dictatorship/forced consensus can decide future's direction, nor improve
> its already low own viability.
>

I see it exactly the same way.

Well I will continue to provide an alternative stack with alternative drivers.
The peer review shows that it doesn't work too well without people participating
fixing problems, the initial drivers were inkernel based and due some updates in
modules which are used by the em28xx some devices which previously worked
don't work anymore in the kernel.

As for the em28xx the driver will use userspace i2c based tuners, decoders and
demodulators.
The userspace modules will use unaltered sample drivers which are provided by
several companies, which also saves alot time in future for that project.
Those drivers will also officially be provided and recommended by the
manufacturing company of those devices, including the proper firmware.
Personally I won't spend any time on reinventing the wheel and fixing drivers
which get broken by not taking care of it.

Beside that people are welcome to contribute without having to fear a political
overhead of discussing requirements and other issues when changing the
corresponding alternative core code. The project and how it will/should go on
is documented at mcentral.de.

I also see that as a good way for the community, that way the linuxtv guys
have to prove that they can be open to other people without adding too
much noise and overhead otherwise people will contribute to the alternative
project as some already do.

Markus
