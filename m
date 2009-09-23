Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZIWLhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZIWLhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZIWLhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:37:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:48968 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZIWLhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:37:36 -0400
Date: Wed, 23 Sep 2009 20:36:32 +0900
To: lmb@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, lars.ellenberg@linbit.com,
       arjan@infradead.org, jens.axboe@oracle.com, neilb@suse.de,
       hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090922062034.GE22732@suse.de>
References: <20090921165321.GJ8072@barkeeper1-xen.linbit>
	<20090922072617U.fujita.tomonori@lab.ntt.co.jp>
	<20090922062034.GE22732@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090923203531C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 23 Sep 2009 20:36:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 08:20:34 +0200
Lars Marowsky-Bree <lmb@suse.de> wrote:

> On 2009-09-22T07:27:21, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > If it happens, once that happens, that _will_ be an ABI break.
> > 
> > You misunderstand the raid unification.
> > 
> > We will not unify the kernel<->userspace configuration interface
> > because we can't break the kernel<->userspace ABI.
> 
> I disagree here. Who says we can't over time, and with due notice?
> 
> For sure, the new ABI needs to co-exist with the old ones for a while,
> until it is proven and fully complete, but then, why can't the old one
> be marked as depreciated and phased out over 1-2 years time?

Let me know If you find a Linux storage developer who say, "Yeah, we
can remove the md ABI over 1-2 years time after the raid unification".

Seems that you have a very different idea from other kernel developers
about the stable ABI.


> > We plan to unify the multiple device frameworks, but the unified
> > framework must support the all existing ABIs.
> > 
> > So adding another 'drbd' ABI hurts us.
> 
> Even that doesn't really apply, I think. If the new framework is
> powerful enough and a super-set of everything that came before, the shim
> layer will be somewhat annoying, but harmless code.

Improving the existing framework is a proper approach.
