Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbXHJCWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbXHJCWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXHJCWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:22:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33059 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753807AbXHJCWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:22:43 -0400
Date: Fri, 10 Aug 2007 04:22:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070810022229.GE18938@stusta.de>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070810020040.GK8424@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 07:00:40PM -0700, Paul E. McKenney wrote:
> On Fri, Aug 10, 2007 at 03:31:46AM +0200, Adrian Bunk wrote:
> > On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.23-rc2-mm1:
> > >...
> > > +allow-rcutorture-to-handle-synchronize_sched.patch
> > >...
> > >  2.6.23 queue
> > >...
> > 
> > All drivers were converted to no longer use xtime directly since it 
> > might be quite outdated, but this patch adds a usage of xtime.tv_nsec
> > as RNG...
> 
> This code doesn't care if the time is outdated, as it is simply
> periodically perturbing an RNG, but OK.
>...

I should have been a bit more concrete:

I have a patch pending to unexport xtime for catching unsafe usages, and 
you added an (ab)user.

> 							Thanx, Paul

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

