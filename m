Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZHMHHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZHMHHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZHMHHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:07:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:60140 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbZHMHHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:07:38 -0400
Date: Thu, 13 Aug 2009 16:07:20 +0900
To: benh@kernel.crashing.org, mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@lists.ozlabs.org,
       galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1250142522.3587.110.camel@pasglop>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1250142522.3587.110.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 16:07:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 15:48:42 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2009-08-05 at 14:08 +0900, FUJITA Tomonori wrote:
> 
> > The above swiotlb patchset was merged in -tip so I think that merging
> > this patchset via -tip too is the easiest way to handle this patchset.
> > 
> > The patchset also is available via a git tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc
> 
> Hi !
> 
> While I generally agree here with the patches, I'm not sure it should be
> merged via -tip since it mostly touches arch/powerpc files (and I need
> to review it a bit more carefully, hopefully you'll have Ack's hitting
> your mailbox later today).

Thanks!

This patchset depends on my swiotlb cleanup patchset:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb

http://marc.info/?l=linux-ia64&m=124718816520156&w=2


My swiotlb cleanup patchset has been in -tip. It might be easier to
merge both the swiotlb patchset and this patchset in powerpc tree?
