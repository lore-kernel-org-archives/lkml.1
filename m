Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXGIIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXGIIr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXGIIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 04:47:49 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:22842 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316AbXGIIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 04:47:49 -0400
X-YMail-OSG: tX3qQ1IVM1lCtNjpeYf.nh9osZLNFgBlt_Y4IH43EfDhs9JfKLd6VqCOpe.jmDztblHPniZ62MHm_OB.45UrWzOZLg--
X-RocketYMMF: knobi.rm
Date: Mon, 9 Jul 2007 01:47:48 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490707081428p11a9b728m8cec7cc2a122d907@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <212660.59998.qm@web32605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jesper Juhl <jesper.juhl@gmail.com> wrote:

> On 05/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > On 05/07/07, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> > > Hi,
> > >
> >
> > I'd suspect you can't get both at 100%.
> >
> > I'd guess you are probably using a 100Hz no-preempt kernel.  Have
> you
> > tried a 1000Hz + preempt kernel?   Sure, you'll get a bit lower
> > overall throughput, but interactive responsiveness should be better
> -
> > if it is, then you could experiment with various combinations of
> > CONFIG_PREEMPT, CONFIG_PREEMPT_VOLUNTARY, CONFIG_PREEMPT_NONE and
> > CONFIG_HZ_1000, CONFIG_HZ_300, CONFIG_HZ_250, CONFIG_HZ_100 to see
> > what gives you the best balance between throughput and interactive
> > responsiveness (you could also throw CONFIG_PREEMPT_BKL and/or
> > CONFIG_NO_HZ, but I don't think the impact will be as significant
> as
> > with the other options, so to keep things simple I'd leave those
> out
> > at first) .
> >
> > I'd guess that something like CONFIG_PREEMPT_VOLUNTARY +
> CONFIG_HZ_300
> > would probably be a good compromise for you, but just to see if
> > there's any effect at all, start out with CONFIG_PREEMPT +
> > CONFIG_HZ_1000.
> >
> 
> I'm currious, did you ever try playing around with CONFIG_PREEMPT*
> and
> CONFIG_HZ* to see if that had any noticable impact on interactive
> performance and stuff like logging into the box via ssh etc...?
> 
> -- 
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
> 
> 
Hi Jesper,

 my initial kernel was voluntary@100HZ. I have switched to 300HZ, but
have not observed much difference. The config is now:

config-2.6.22-rc7:# CONFIG_PREEMPT_NONE is not set
config-2.6.22-rc7:CONFIG_PREEMPT_VOLUNTARY=y
config-2.6.22-rc7:# CONFIG_PREEMPT is not set
config-2.6.22-rc7:CONFIG_PREEMPT_BKL=y

Cheers


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
