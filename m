Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZDOMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZDOMqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759523AbZDOMqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:46:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46404 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378AbZDOMqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:46:02 -0400
Date: Wed, 15 Apr 2009 14:46:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090415124601.GM5178@kernel.dk>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca> <20090414175433.GY14687@one.firstfloor.org> <49E4D16C.7030809@msgid.tls.msk.ru> <20090414185058.GZ14687@one.firstfloor.org> <1239737226.28321.22.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239737226.28321.22.camel@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14 2009, Chris Mason wrote:
> On Tue, 2009-04-14 at 20:50 +0200, Andi Kleen wrote:
> > On Tue, Apr 14, 2009 at 10:09:48PM +0400, Michael Tokarev wrote:
> > > Andi Kleen wrote:
> > > []
> > > >Where I see it as a problem is with virtualization; LVM seems to be the
> > > >most sane way to manage file systems for lots of VMs and you likely
> > > >want barriers there too.
> > > 
> > > Virtualisation is the best fit for partitionable raid1 arrays.
> > > It is, in fact, what we have here -- I tested LVM but rejected
> > > it because of this very issue - it does not support barriers.
> > 
> > It does now as of 2.6.29, as long as you only have a single
> > underlying device and use dm linear.
> 
> Eric Sandeen noticed this is actually still broken:
> 
> http://lkml.org/lkml/2009/3/23/360

Alasdair promised to push the remaining barrier bits for 2.6.30, so
hopefully it should all be in working order Real Soon Now.

-- 
Jens Axboe

