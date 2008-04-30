Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYD3Jkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYD3Jkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYD3JkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:40:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:46321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756861AbYD3JkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:40:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kMegpTfmk7SESnLFjX3hKEQAVKvXPCRcuWQ/PBp
	0tPswNDMLW1SFa
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: Mike Galbraith <efault@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       mchehab@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20080430092606.GB31644@uranus.ravnborg.org>
References: <20080429185009.716c3284@gaivota>
	 <20080430074807.GA11224@elte.hu>
	 <20080430.005212.46815036.davem@davemloft.net>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
	 <1209545784.31419.2.camel@marge.simson.net>
	 <20080430092606.GB31644@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 11:40:03 +0200
Message-Id: <1209548403.9668.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 11:26 +0200, Sam Ravnborg wrote:

> > > > 
> > > > You also have to make clean after today's pull or...
> > > > 
> > > > Kernel: arch/x86/boot/bzImage is ready  (#3)
> > > > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "microtune_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "simple_tuner_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tda9887_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "xc5000_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "xc2028_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tda829x_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> > > > ERROR: "xc2028_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > > ERROR: "simple_tuner_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > > ERROR: "tda827x_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > 
> > > Hm, so I thought.  Error is constant.  Going back to .yesterday.
> > 
> > Turning CONFIG_MEDIA_ATTACH on fixed it.  I must have switched it somehow before.
> 
> So you did not have to do a make clean to make it build?
> If make clean is needed then we have an issue in kbuild.

I would have _sworn_ I did, but am unsure now.  (if so, someone else
will hit it)

	-Mike

