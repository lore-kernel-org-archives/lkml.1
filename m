Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXDDVzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXDDVzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXDDVzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:55:33 -0400
Received: from smtp.knology.net ([24.214.63.101]:50541 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXDDVzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:55:32 -0400
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
From: Dave Dillow <dave@thedillows.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       amanda-hackers@amanda.org, amanda-users@amanda.org
In-Reply-To: <20070404132949.f6fbca9f.akpm@linux-foundation.org>
References: <200704010100.19016.gene.heskett@verizon.net>
	 <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
	 <200704011141.53105.gene.heskett@verizon.net>
	 <200704020021.02393.gene.heskett@gmail.com>
	 <1175488272.3161.28.camel@obelisk.thedillows.org>
	 <1175661256.31439.23.camel@obelisk.thedillows.org>
	 <20070404084530.GB1556@elte.hu>
	 <20070404104219.40e25b6a.akpm@linux-foundation.org>
	 <1175710634.27756.40.camel@dillow.idleaire.net>
	 <20070404132949.f6fbca9f.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 17:55:28 -0400
Message-Id: <1175723728.6274.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 13:29 -0700, Andrew Morton wrote:
> On Wed, 04 Apr 2007 14:17:13 -0400
> Dave Dillow <dave@thedillows.org> wrote: 
> > The thing is, it's been broken for a long time -- this change just
> > highlighted it. This isn't the first time that device-mapper has moved
> > -- the introduction of mdp (before git, so haven't tracked down
> > timeframe) also moved it around. The dynamic major is not stable, so
> > should we be concerned if it moves for 2.6.21?
> > 
> > I don't like the effect it has on the backups, but I don't think we
> > should hand out LOCAL/EXP majors to dynamic devices, either. There is a
> > module option to make the device-mapper and mdp majors stable, so
> > perhaps a compromise is possible? Revert for 2.6.21, and schedule the
> > patch for later addition, which gives distros time to use the DM major
> > option?
> 
> hm, good points.
> 
> Overall, the patch helps kernel developers and hurts the userbase.  I tend
> to prefer to hurt kernel developers than our users ;)
> 
> I don't think the protect-lanana-numbers thing is very important, really. 
> If some kernel developer or someone who is maintaining an unofficial
> out-of-tree driver hits the problem, they are presumably able to handle
> it.  Preferably by switching to a dynamically-assigned major.

Works for me; I don't really have a dog in the fight.
