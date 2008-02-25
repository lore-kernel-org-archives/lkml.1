Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYBYLdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYBYLdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYBYLde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:33:34 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53416 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYBYLdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:33:33 -0500
Date: Mon, 25 Feb 2008 13:32:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225113235.GC32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225111707.GA7062@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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

How do you test whether a x86 merge might break the compilation of 
e.g. some ARM platform without using any defconfig?

And building all defconfigs is the trivial way of having most reasonable 
configurations covered with only one day of compile time.

> More defconfigs would just be a constant maintenance drag, they are 
> rather pointless on PC hardware anyway (we'd have to have at least a few 
> hundred of them for it to be meaningful as a "default config") and it 
> does not really solve the problem either.

My goal was "one per subarchitecture" which is not such a big number.

At least for the patches I'm sending more defconfigs reduce the 
probability of me introducing bugs (and I might e.g. again work
a bit on improving our headers mess in the future).

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

