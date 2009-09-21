Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZIUW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZIUW20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZIUW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:28:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:59111 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZIUW2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:28:25 -0400
Date: Tue, 22 Sep 2009 07:27:21 +0900
To: lars.ellenberg@linbit.com
Cc: arjan@infradead.org, fujita.tomonori@lab.ntt.co.jp, lmb@suse.de,
       jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090921165321.GJ8072@barkeeper1-xen.linbit>
References: <20090921144308.GG8072@barkeeper1-xen.linbit>
	<20090921165252.04e335b1@infradead.org>
	<20090921165321.GJ8072@barkeeper1-xen.linbit>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090922072617U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 22 Sep 2009 07:27:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 18:53:21 +0200
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Mon, Sep 21, 2009 at 04:52:52PM +0200, Arjan van de Ven wrote:
> > On Mon, 21 Sep 2009 16:43:08 +0200
> > Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> > > We can choose whatever user-kernel interface you like,
> > > and change it with every dot release --
> > > we'd just need to add additional compat code into
> > > the drbdsetup userland binary.
> > 
> > uh no.
> > 
> > the kernel<->userspace ABI is stable.
> > we don't go about randomly changing it
> > (extending it is fine obviously)
> 
> That's not what I meant, of course that is and needs to be stable.
> Sorry, I exagerated to make a point.
> 
> Point was:
> mdadm configured md.
> dmsetup configured dm.
> drbdsetup configure drbd.
> 
> If and when "something" is done to "unify" things on the implementation
> level, it is likely to also unify the "kernel<->userspace" configuration
> interface.
> 
> If it happens, once that happens, that _will_ be an ABI break.

You misunderstand the raid unification.

We will not unify the kernel<->userspace configuration interface
because we can't break the kernel<->userspace ABI.

We plan to unify the multiple device frameworks, but the unified
framework must support the all existing ABIs.

So adding another 'drbd' ABI hurts us.
