Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZIWXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZIWXii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbZIWXii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:38:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:34315 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZIWXih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:38:37 -0400
Date: Thu, 24 Sep 2009 08:37:14 +0900
To: neilb@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, lmb@suse.de, lars.ellenberg@linbit.com,
       arjan@infradead.org, jens.axboe@oracle.com, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <19130.43495.807916.962040@notabene.brown>
References: <20090922062034.GE22732@suse.de>
	<20090923203531C.fujita.tomonori@lab.ntt.co.jp>
	<19130.43495.807916.962040@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090924083617J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 24 Sep 2009 08:37:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 09:06:15 +1000
Neil Brown <neilb@suse.de> wrote:

> On Wednesday September 23, fujita.tomonori@lab.ntt.co.jp wrote:
> > On Tue, 22 Sep 2009 08:20:34 +0200
> > Lars Marowsky-Bree <lmb@suse.de> wrote:
> > 
> > > On 2009-09-22T07:27:21, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > > If it happens, once that happens, that _will_ be an ABI break.
> > > > 
> > > > You misunderstand the raid unification.
> > > > 
> > > > We will not unify the kernel<->userspace configuration interface
> > > > because we can't break the kernel<->userspace ABI.
> > > 
> > > I disagree here. Who says we can't over time, and with due notice?
> > > 
> > > For sure, the new ABI needs to co-exist with the old ones for a while,
> > > until it is proven and fully complete, but then, why can't the old one
> > > be marked as depreciated and phased out over 1-2 years time?
> > 
> > Let me know If you find a Linux storage developer who say, "Yeah, we
> > can remove the md ABI over 1-2 years time after the raid unification".
> 
> I would have said 3-5 years, that being about the time frame for
> enterprise releases, and it would be best if every enterprise vendor

Enterprise vendors don't pick up the latest kernel. So I think that we
need more.


> got to have a release that supported both the old and the new
> interface.  But I don't have a problem with migrating to a better ABI
> is we actually had a better ABI.
> > 
> > Seems that you have a very different idea from other kernel developers
> > about the stable ABI.
> 
> CONFIG_SYSFS_DEPRECATED_V2  seems to suggest that other kernel
> developers understand that we sometimes make mistakes and need to
> deprecate them.

Yeah, however, we can try not to make mistakes.


> However I think this is all very premature as there is even a coherent
> proposal for what unification might look like, let alone broad
> agreement or implementation.  I would *much* rather we spent our
> energies debating that than debating whether or not DRBD should get
> merged.... Maybe would should only accept votes on "Should DRBD get
> merged" from people provide constructive input to the question "what
> would a unified virtual block device model look like".
> 
> > 
> > Improving the existing framework is a proper approach.
> 
> Yes.  So let's do it.

So we should implement something like drbd on the top of dm framework,
one of the existing 'virtual device' frameworks. That would improve dm
and we could get better ideas about "what would a unified virtual
block device model look like".
