Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXDNM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXDNM0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 08:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965536AbXDNM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 08:26:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50368 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965526AbXDNM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 08:26:23 -0400
Date: Sat, 14 Apr 2007 14:26:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414122629.GD3691@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413212954.GA2545@melchior.yamamaya.is-a-geek.org> <20070413235017.GR5907@stusta.de> <20070414081619.GA24909@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070414081619.GA24909@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 10:16:19AM +0200, Tobias Diedrich wrote:
> Adrian Bunk wrote:
> > On Fri, Apr 13, 2007 at 11:29:55PM +0200, Tobias Diedrich wrote:
> > > Linus Torvalds wrote:
> > > 
> > > > We should be getting close to a 2.6.21 release, so please update any 
> > > > regression reports you've done,
> > > 
> > > For me, suspend to disk works only once (has been the case for all
> > > .21-rcs IIRC, but I didn't get around to report it so far).
> > > There are some threads about an issue like this, which is supposed
> > > to be fixed by disabling CONFIG_PCI_MSI, but on my system the
> > > problem persists nonetheless.
> > > 
> > > On the second suspend attempt, the last message I see is
> > > "Suspending console(s)"
> > > 
> > > If I find the time, I'll try to bisect it this weekend.
> > >...
> > 
> > Does the latest -git work?
> 
> Still no luck with
> Linux melchior 2.6.21-rc6-gd791d413-dirty #4 PREEMPT Sat Apr 14 09:34:21 CEST 2007 x86_64 GNU/Linux
> Why -dirty? Maybe because I modified the Makefile to use ccache?
> 
> > Does CONFIG_HPET_TIMER=n make any difference?
> 
> Hmm, I just noticed that CONFIG_HPET_TIMER was forced back on after
> make oldconfig...  Is that expected on amd64?
>...

Yes it is (on i386 you can disable it).
Sorry that I missed this.

> Tobias						PGP: http://9ac7e0bc.uguu.de

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

