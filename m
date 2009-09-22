Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZIVGVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZIVGVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZIVGVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:21:08 -0400
Received: from gate.in-addr.de ([212.8.193.158]:36302 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754552AbZIVGVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:21:07 -0400
Date: Tue, 22 Sep 2009 08:20:34 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lars.ellenberg@linbit.com
Cc: arjan@infradead.org, jens.axboe@oracle.com, neilb@suse.de,
       hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090922062034.GE22732@suse.de>
References: <20090921144308.GG8072@barkeeper1-xen.linbit> <20090921165252.04e335b1@infradead.org> <20090921165321.GJ8072@barkeeper1-xen.linbit> <20090922072617U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090922072617U.fujita.tomonori@lab.ntt.co.jp>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-22T07:27:21, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > If it happens, once that happens, that _will_ be an ABI break.
> 
> You misunderstand the raid unification.
> 
> We will not unify the kernel<->userspace configuration interface
> because we can't break the kernel<->userspace ABI.

I disagree here. Who says we can't over time, and with due notice?

For sure, the new ABI needs to co-exist with the old ones for a while,
until it is proven and fully complete, but then, why can't the old one
be marked as depreciated and phased out over 1-2 years time?

Users won't notice. Modern distros will switch, and in cases of legacy
distros ("enterprise"), the vendors will backport appropriately.

This happens. There's precedence with the network filtering rules etc.

> We plan to unify the multiple device frameworks, but the unified
> framework must support the all existing ABIs.
> 
> So adding another 'drbd' ABI hurts us.

Even that doesn't really apply, I think. If the new framework is
powerful enough and a super-set of everything that came before, the shim
layer will be somewhat annoying, but harmless code.


Regards,
    Lars

-- 
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

