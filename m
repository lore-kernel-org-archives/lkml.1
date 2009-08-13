Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZHMGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZHMGwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZHMGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:52:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:52924 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbZHMGwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:52:18 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1250142522.3587.110.camel@pasglop>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 16:51:53 +1000
Message-Id: <1250146313.3587.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 16:44 +1000, Benjamin Herrenschmidt wrote:
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

Maybe best is that I pull your series too. Note that your patch clashes
with Takashi's addition of dma_mmap_coherent() :

http://patchwork.ozlabs.org/patch/29595/

Can you sort that out with Takashi as I'd like his patch in -next soon
too.

Cheers,
Ben.


