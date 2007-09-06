Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbXIFJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbXIFJu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXIFJuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:50:13 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:28182 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754663AbXIFJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:50:11 -0400
X-YMail-OSG: gl8NLE8VM1mHpenIHgMu8RBIGrw6WkRWyFCkpBNlWGZVDBRtnFm.WvyXe.vfKfThOFkfZ6lcQfSTpwEjAmXaIgKOGQ--
X-RocketYMMF: knobi.rm
Date: Thu, 6 Sep 2007 02:50:10 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: huge improvement with per-device dirty throttling
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>,
       linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Peter zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <713371.64716.qm@web32603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <351207.28447.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Martin Knoblauch <knobi@knobisoft.de> wrote:

> 
> --- Leroy van Logchem <leroy.vanlogchem@wldelft.nl> wrote:
> 
> > Andrea Arcangeli wrote:
> > > On Wed, Aug 22, 2007 at 01:05:13PM +0200, Andi Kleen wrote:
> > >> Ok perhaps the new adaptive dirty limits helps your single disk
> > >> a lot too. But your improvements seem to be more "collateral
> > damage" @)
> > >>
> > >> But if that was true it might be enough to just change the dirty
> > limits
> > >> to get the same effect on your system. You might want to play
> with
> > >> /proc/sys/vm/dirty_*
> > > 
> > > The adaptive dirty limit is per task so it can't be reproduced
> with
> > > global sysctl. It made quite some difference when I researched
> into
> > it
> > > in function of time. This isn't in function of time but it
> > certainly
> > > makes a lot of difference too, actually it's the most important
> > part
> > > of the patchset for most people, the rest is for the corner cases
> > that
> > > aren't handled right currently (writing to a slow device with
> > > writeback cache has always been hanging the whole thing).
> > 
> > 
> > Self-tuning > static sysctl's. The last years we needed to use very
> 
> > small values for dirty_ratio and dirty_background_ratio to soften
> the
> > 
> > latency problems we have during sustained writes. Imo these patches
> 
> > really help in many cases, please commit to mainline.
> > 
> > -- 
> > Leroy
> > 
> 
>  while it helps in some situations, I did some tests today with
> 2.6.22.6+bdi-v9 (Peter was so kind) which seem to indicate that it
> hurts NFS writes. Anyone seen similar effects?
> 
>  Otherwise I would just second your request. It definitely helps the
> problematic performance of my CCISS based RAID5 volume.
> 

 please disregard my comment about NFS write performance. What I have
seen is caused by some other stuff I am toying with.

 So, I second your request to push this forward.

Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
