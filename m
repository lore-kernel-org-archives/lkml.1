Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZIUQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZIUQxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZIUQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:53:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34189 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZIUQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:53:19 -0400
Date: Mon, 21 Sep 2009 18:53:21 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lmb@suse.de,
       jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090921165321.GJ8072@barkeeper1-xen.linbit>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lmb@suse.de,
	jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
	James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
	bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
	kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
	torvalds@linux-foundation.org, nab@linux-iscsi.org,
	knikanth@suse.de, philipp.reisner@linbit.com, sam@ravnborg.org,
	Mauelshagen@RedHat.com
References: <20090918200803.GM23126@kernel.dk> <20090919141334N.fujita.tomonori@lab.ntt.co.jp> <20090919220232.GB31849@suse.de> <20090921223815U.fujita.tomonori@lab.ntt.co.jp> <20090921144308.GG8072@barkeeper1-xen.linbit> <20090921165252.04e335b1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921165252.04e335b1@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 04:52:52PM +0200, Arjan van de Ven wrote:
> On Mon, 21 Sep 2009 16:43:08 +0200
> Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> > We can choose whatever user-kernel interface you like,
> > and change it with every dot release --
> > we'd just need to add additional compat code into
> > the drbdsetup userland binary.
> 
> uh no.
> 
> the kernel<->userspace ABI is stable.
> we don't go about randomly changing it
> (extending it is fine obviously)

That's not what I meant, of course that is and needs to be stable.
Sorry, I exagerated to make a point.

Point was:
mdadm configured md.
dmsetup configured dm.
drbdsetup configure drbd.

If and when "something" is done to "unify" things on the implementation
level, it is likely to also unify the "kernel<->userspace" configuration
interface.

If it happens, once that happens, that _will_ be an ABI break.

One way to go about it would be to just do that excellently designed and
generic and extensible and whatnot new kernel<->userspace thing, and add
the necessary compat cruft to the above mentioned configuration tools.

Doing the drbdsetup part of it would be our part,
which we would gladly accept.

Not speaking that not yet designed all-new unified config interface
is not a valid argument against DRBD inclusion.

	Lars
