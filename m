Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbXGOXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbXGOXqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762965AbXGOXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:46:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34161 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756287AbXGOXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:46:24 -0400
Date: Mon, 16 Jul 2007 01:45:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Message-ID: <20070715234543.GN3565@stusta.de>
References: <5FD5754DDBA0B1499B5A0B4BB54194850164B1F6@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB54194850164B1F6@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 10:47:51AM -0700, Li, Tong N wrote:
> > On Thursday 12 July 2007 00:17, Al Boldi wrote:
> > 
> > > Peter Williams wrote:
> > >>
> > >> Probably the last one now that CFS is in the main line :-(.
> > >
> > > What do you mean?  A pluggable scheduler framework is indispensible
> even
> > in
> > > the presence of CFS or SD.
> > 
> > Indeed, and I hope it gets merged, giving people the chance to test
> out
> > different schedulers easily, without having to do patching,
> de-patching,
> > re-patching and blah blah blah.
> > 
> 
> Yes, such a framework would be invaluable, especially given that
> scheduling often has conflicting goals and different workloads have
> different requirements. No single solution fits all.
>...

Having a framework for giving people the choice between different 
solutions usually sounds good in theory, but in practice there's the 
often underestimated high price of people using a different solution 
instead of reporting a problem with one solution or people adding 
features to only one of the solutions resulting in different solutions 
having different features and bugs instead of one solution with all 
features and bug fixes.

So you should give a good technical explanation why it's not technically 
possible or not desirable for one solution to work well for everyone.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

