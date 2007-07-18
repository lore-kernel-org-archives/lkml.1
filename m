Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbXGRGjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbXGRGjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXGRGjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:39:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:27453 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXGRGjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qkoZe6jhz8XTR1XtA77XP042+6bZ+cnF1tLFR4NQ8yxvovqURLbeieSKZ4pReqNB1uYGFs4EZI64iZh1JFSFU61/ZvHIwYtcvKG1YhMdqeL9ixHmOYm0ubzGq3MotcUeBT2xjNlRe3VJyhBNF4po6wEiw37VuuDHfaNthMfdAhc=
Message-ID: <2c0942db0707172339o2e4950e0p17cd0f9b631e5311@mail.gmail.com>
Date: Tue, 17 Jul 2007 23:39:00 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070718011436.2438dea6@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <20070716235438.1bdd0722@the-village.bc.nu>
	 <2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
	 <469BF9A8.20306@gmail.com>
	 <2c0942db0707161615g4bdf825ar51464ba564a823e2@mail.gmail.com>
	 <20070718011436.2438dea6@the-village.bc.nu>
X-Google-Sender-Auth: d930913fbdcf3589
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 16 Jul 2007 16:15:28 -0700
> "Ray Lee" <ray-lk@madrabbit.org> wrote:
> > Heh :-). No, it's not a question of trust. First and foremost, it's
> > that there are still users who say that they can crash a current
> > 4k+interrupt stacks kernel, while the 8k without interrupt stacks is
> > fine.
>
> You forgot "most of the time".

Yeah, fair enough.

> Its statistically less likely, which
> merely means its evilly hard to debug

Not being able to debug the cases that occur (and the fact that
they're rare, as you're pointing out) is as much of a problem as the
crashes themselves. 8k + IRQ stacks with a warning when 4k of process
stack is exceeded would seem like a reasonable first step to making 4k
a palatable default.

Ray
