Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYH2JnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYH2JnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYH2Jmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:42:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35807 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYH2Jmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:42:53 -0400
Date: Fri, 29 Aug 2008 11:42:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: linux-next: Tree for August 27
Message-ID: <20080829094249.GQ20055@kernel.dk>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com> <20080829070515.GL20055@kernel.dk> <48B7C361.9070008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7C361.9070008@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> >> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
> >> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
> >> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
> >> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
> >> in no longer bootable systems (+ help entry for the new option says
> >> "Say N if you are unsure.").
> >>
> >> Tejun/Jens: please consider changing this.
> > 
> > I have change the default to 'n' for now.
> 
> Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
> broken?  Did it fail to locate the root partition or were you using
> static device nodes?

It works fine for me, fwiw.

-- 
Jens Axboe

