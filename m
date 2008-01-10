Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYAJJms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYAJJms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYAJJmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:42:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYAJJmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:42:39 -0500
Date: Thu, 10 Jan 2008 10:42:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080110094219.GC17808@elte.hu>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com> <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu> <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com> <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com> <47841C41.4060401@zytor.com> <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
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


* Matthew <jackdachef@gmail.com> wrote:

> > I have been unable to reproduce your problem here, and I notice you have
> > the proprietary, highly invasive and closed-source Nvidia driver
> > installed in your kernel.
> >
> > Can you try using the "nv" or "vesa" (unaccelerated) Xorg drivers and
> > reproduce the problem that way?
> >
> > If you *do* reproduce the problem that way, it would be extremely
> > helpful if you could enable CONFIG_DEBUG_INFO and provide the vmlinux
> > (not vmlinuz/bzImage) file that goes with the crash dump screenshot.
> >
> > Thanks!
> 
> I was able to reproduce it with removed nvidia module (rmmod nvidia) & 
> nv driver, and will post the pictures later if I find some time (it 
> was the same function if I recall right) do you also need: 
> CONFIG_DEBUG_BUGVERBOSE enabled ?

really, that module does all sorts of nasty stuff when inserted (and 
then removed), so just to make sure (because you are about to crash your 
box again to take a picture), could you try to boot up without never 
even once loading the nvidia module?

	Ingo
