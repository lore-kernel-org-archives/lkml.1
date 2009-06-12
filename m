Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbZFLKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbZFLKZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZFLKYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:24:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38438 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFLKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:24:51 -0400
Date: Fri, 12 Jun 2009 12:32:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
Message-ID: <20090612103251.GJ25568@one.firstfloor.org>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org> <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 08:45:29PM +0200, Stefan Lankes wrote:
> > Your patches seem to have a lot of overlap with
> > Lee Schermerhorn's old migrate memory on cpu migration patches.
> > I don't know the status of those.
> 
> I analyze Lee Schermerhorn's migrate memory on cpu migration patches
> (http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that Lee
> Schermerhorn add similar functionalities to the kernel. He called the
> "affinity-on-next-touch" functionality "migrate_on_fault" and uses in his
> patches the normal NUMA memory policies. Therefore, his solution fits better
> to the Linux kernel. I tested his patches with our test applications and got
> nearly the same performance results. 

That's great to know.

I didn't think he had a per process setting though, did he?

> I found only patches for the kernel 2.6.25-rc2-mm1. Does someone develop
> these patches further?

Not to much knowledge. Maybe Lee will pick them up again now that there
are more use cases.

If he doesn't have time maybe you could update them?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
