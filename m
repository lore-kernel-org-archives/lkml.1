Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZFPCZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZFPCZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZFPCZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:25:34 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:8542 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFPCZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:25:33 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Lankes <lankes@lfbs.rwth-aachen.de>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
In-Reply-To: <20090612103251.GJ25568@one.firstfloor.org>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 15 Jun 2009 22:25:32 -0400
Message-Id: <1245119132.6724.32.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 12:32 +0200, Andi Kleen wrote:
> On Thu, Jun 11, 2009 at 08:45:29PM +0200, Stefan Lankes wrote:
> > > Your patches seem to have a lot of overlap with
> > > Lee Schermerhorn's old migrate memory on cpu migration patches.
> > > I don't know the status of those.
> > 
> > I analyze Lee Schermerhorn's migrate memory on cpu migration patches
> > (http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that Lee
> > Schermerhorn add similar functionalities to the kernel. He called the
> > "affinity-on-next-touch" functionality "migrate_on_fault" and uses in his
> > patches the normal NUMA memory policies. Therefore, his solution fits better
> > to the Linux kernel. I tested his patches with our test applications and got
> > nearly the same performance results. 
> 
> That's great to know.
> 
> I didn't think he had a per process setting though, did he?

Hi, Andi.

My patches don't have per process enablement.  Rather, I chose to use
per cpuset enablement.  I view cpusets as sort of "numa control groups"
and thought this was an appropriate level at which to control this sort
of behavior--analogous to memory_spread_{page|slab}.  That probably
needs to be discussed more widely, tho'.

> 
> > I found only patches for the kernel 2.6.25-rc2-mm1. Does someone develop
> > these patches further?
> 
> Not to much knowledge. Maybe Lee will pick them up again now that there
> are more use cases.
> 
> If he doesn't have time maybe you could update them?

As I mentioned earlier, I need to sort out the interaction with the
memory controller.  It was changing too fast for me to keep up in the
time I could devote to it.

Lee

