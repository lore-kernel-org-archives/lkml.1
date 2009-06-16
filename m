Return-Path: <linux-kernel-owner+w=401wt.eu-S1764848AbZFPCjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764848AbZFPCjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZFPCjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:39:44 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3112 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZFPCjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:39:43 -0400
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
In-Reply-To: <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 15 Jun 2009 22:39:37 -0400
Message-Id: <1245119977.6724.40.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 13:46 +0200, Stefan Lankes wrote:
> > > I analyze Lee Schermerhorn's migrate memory on cpu migration patches
> > > (http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that
> > Lee
> > > Schermerhorn add similar functionalities to the kernel. He called the
> > > "affinity-on-next-touch" functionality "migrate_on_fault" and uses in
> > his
> > > patches the normal NUMA memory policies. Therefore, his solution fits
> > better
> > > to the Linux kernel. I tested his patches with our test applications
> > and got
> > > nearly the same performance results.
> > 
> > That's great to know.
> > 
> > I didn't think he had a per process setting though, did he?
> 
> He enables the support of migration-on-fault via cpusets (echo 1 >
> /dev/cpuset/migrate_on_fault).
> Afterwards, every process could initiate migration-on-fault via mbind(...,
> MPOL_MF_MOVE|MPOL_MF_LAZY).

I should have read through the entire thread before responding Andi's
mail.

> 
> > > I found only patches for the kernel 2.6.25-rc2-mm1. Does someone
> > develop
> > > these patches further?
> > 
> > Not to much knowledge. Maybe Lee will pick them up again now that there
> > are more use cases.
> > 
> > If he doesn't have time maybe you could update them?
>  
> We are planning to work in this area. I think that I could update these
> patches. 
> At least, I am able to support Lee.

I would like to get these patches working with latest mmotm to test on
some newer hardware where I think they will help more.  And I would
welcome your support.  However, I think we'll need to get Balbir and
Kamezawa-san involved to sort out the interaction with memory control
group.

I can send you the more recent rebase that I've done.  This is getting
pretty old now:  2.6.28-rc4-mmotm-081110-081117.  I'll try to rebase to
the most recent mmotm [that boots on my platforms], at least so that we
can build and boot with migrate-on-fault disabled, within the next
couple of weeks.  

Regards,
Lee

