Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYBYTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYBYTCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYBYTCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:02:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59828 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbYBYTCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:02:32 -0500
Date: Mon, 25 Feb 2008 20:02:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225190241.GA23161@uranus.ravnborg.org>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225111707.GA7062@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 12:17:07PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > What I want is that e.g. after fiddling with kernel headers I want an 
> > easy way of having much compile coverage. And my script that builds 
> > all defconfig's is trivial (although it takes a day to finish).
> 
> no, i think you misunderstood me. I do allyesconfig testing to make sure 
> the kernel is still generic enough on PC hardware - not to catch build 
> breakage.
> 
> What i do against build breakage is randconfig testing. That catches far 
> more build breakage than a few limited number of defconfigs would ever.

Fully agreed.
But to do a few number of repetitive builds over time makes it much easier
to see if something are degenerating.

I could save a selected number of handcrafted configs so I was sure to
cover relevant different configs. But then I had to find out the
typical configuration of various sub-architectures etc.

And asking me to do randconfig is not an option. I have only this
machine to work on and with a -j8 build it gets unresponsive at least
so much that it irritates me.
 
> More defconfigs would just be a constant maintenance drag, they are 
> rather pointless on PC hardware anyway (we'd have to have at least a few 
> hundred of them for it to be meaningful as a "default config") and it 
> does not really solve the problem either.
10 different configs would cover what I have in mind. This is not all
sort of combinations of dirvers and kernel haching options multiplied
with the arch specific options. This is the typical set of options
that is used to build a kernel to the relevant sub-architectures.

And an occasional defconfig update are not a maintanence burden.

It is a simple equation: 10 additional defconfigs can give you more
build coverage by additional people. Is it worth it?

	Sam
