Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbYD3Khi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbYD3Khi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYD3Kha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:37:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYD3Kha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:37:30 -0400
Date: Wed, 30 Apr 2008 12:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       mchehab@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430103642.GA3482@elte.hu>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu> <20080430.005212.46815036.davem@davemloft.net> <20080430081345.GA16519@elte.hu> <1209544030.30990.2.camel@marge.simson.net> <1209544951.15609.3.camel@marge.simson.net> <1209545784.31419.2.camel@marge.simson.net> <20080430092606.GB31644@uranus.ravnborg.org> <1209548403.9668.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209548403.9668.3.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> 
> On Wed, 2008-04-30 at 11:26 +0200, Sam Ravnborg wrote:
> 
> > > > > 
> > > > > You also have to make clean after today's pull or...
> > > > > 
> > > > > Kernel: arch/x86/boot/bzImage is ready  (#3)
> > > > > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "microtune_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "simple_tuner_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tda9887_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "xc5000_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "xc2028_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tda829x_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> > > > > ERROR: "xc2028_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > > > ERROR: "simple_tuner_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > > > ERROR: "tda827x_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > > 
> > > > Hm, so I thought.  Error is constant.  Going back to .yesterday.
> > > 
> > > Turning CONFIG_MEDIA_ATTACH on fixed it.  I must have switched it somehow before.
> > 
> > So you did not have to do a make clean to make it build?
> > If make clean is needed then we have an issue in kbuild.
> 
> I would have _sworn_ I did, but am unsure now.  (if so, someone else
> will hit it)

btw., this second fix might be related to that failure:

  http://lkml.org/lkml/2008/4/30/108

	Ingo
