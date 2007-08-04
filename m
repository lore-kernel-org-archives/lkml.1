Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbXHDWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbXHDWj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbXHDWjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:39:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55718 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762904AbXHDWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:39:46 -0400
Date: Sun, 5 Aug 2007 01:39:42 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "J??rn Engel" <joern@logfs.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <20070804202830.GA4538@elte.hu>
Message-ID: <Pine.LNX.4.64.0708050054220.2865@kivilampi-30.cs.helsinki.fi>
References: <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
 <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
 <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
 <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
 <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu>
 <20070804202830.GA4538@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, Ingo Molnar wrote:

> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > People just need to know about the performance differences - very few 
> > realise its more than a fraction of a percent. I'm sure Gentoo will 
> > use relatime the moment anyone knows its > 5% 8)
> 
> noatime,nodiratime gave 50% of wall-clock kernel rpm build performance 
> improvement for Dave Jones, on a beefy box. Unless i misunderstood what 
> you meant under 'fraction of a percent' your numbers are _WAY_ off. 
> Atime updates are a _huge everyday deal_, from laptops to servers. 
> Everywhere on the planet. Give me a Linux desktop anywhere and i can 
> tell you whether it has atimes on or off, just by clicking around and 
> using apps (without looking at the mount options). That's how i notice 
> it that i forgot to turn off atime on any newly installed system - the 
> system has weird desktop lags and unnecessary disk trashing.

...For me, I would say 50% is not enough to describe the _visible_ 
benefits... Not talking any specific number but past 10sec-1min+ lagging
in X is history, it's gone and I really don't miss it that much... :-) 
Cannot reproduce even a second long delay anymore in window focusing under 
considerable load as it's basically instantaneous (I can see that it's 
loaded but doesn't affect the feeling of responsiveness I'm now getting), 
even on some loads that I couldn't previously even dream of... I still
can get drawing lag a bit by pushing enough stuff to swap but still it's 
definately quite well under control, though rare 1-2 sec spikes in drawing 
appear due to swap loads I think. ...And this is 2.6.21.5 so no fancies 
ala Ingo's CFS or so yet...

...Thanks about this hint. :-)

-- 
 i.
