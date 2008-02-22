Return-Path: <linux-kernel-owner+w=401wt.eu-S935788AbYBVBHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935788AbYBVBHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYBVBHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:07:45 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58780 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYBVBHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:07:44 -0500
Date: Fri, 22 Feb 2008 03:06:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Roland Dreier <rdreier@cisco.com>, Linus Torvalds <torvalds@osdl.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222010659.GG28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <20080221213037.GA24191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080221213037.GA24191@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:30:37PM -0800, Greg KH wrote:
> On Thu, Feb 21, 2008 at 11:01:24PM +0200, Adrian Bunk wrote:
> > 
> > BTW: Greg, you are Cc'ed for your joke in [3]...
> 
> > [3] http://lkml.org/lkml/2008/2/12/427
> 
> That was not a joke, I ment it.  Do you have proof that the majority of
> patches going into the kernel tree are not reviewed by at least 2
> people?
>...

I don't see any way for getting a proof in any direction, but no matter 
how many SOB lines a patch has my impression is that usually at a 
maximum the one person who applies a patch reviews it ("review" as in 
"understands the code in question well and reviews the patch line for 
line").

Sometimes there's even simply noone who could a patch at all, e.g. I'm 
not sure whether there is anyone at all who would be able to review a 
patch by Sam fiddling with kbuild internals.

How many lines of code get changed in the kernel per day?

And we should have for each changed line two people who are both
experienced enough in this area of the kernel and who have the time to
review this line?

Even one of our best maintained subsystems has commits that contain
bugs like

+       if ((!tid_agg_rx->reorder_buf) && net_ratelimit()) {
+               printk(KERN_ERR "can not allocate reordering buffer "
+                                               "to tid %d\n", tid);
+               goto end;
+       }

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

