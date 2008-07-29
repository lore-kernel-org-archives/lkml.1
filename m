Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYG2Bs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYG2Bs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYG2BsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:48:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:49659 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYG2BsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:48:19 -0400
Date: Tue, 29 Jul 2008 10:46:31 +0900
To: sfr@canb.auug.org.au
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080729110749.728c54e6.sfr@canb.auug.org.au>
References: <20080725233325W.fujita.tomonori@lab.ntt.co.jp>
	<20080726134156.GC4401@elte.hu>
	<20080729110749.728c54e6.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729104722H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 11:07:49 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Sat, 26 Jul 2008 15:41:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > ok, i'll apply the 3 patches to tip/x86/iommu. As usual, feel free to 
> > send IOMMU cleanups/generalizations/fixes against tip/master:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> 
> So, I assume a patch created on July 25 is not destined for 2.6.27,

Hmm, seems that they will go into 2.6.27:

http://marc.info/?l=linux-kernel&m=121729275722287&w=2


> right?  Especially since it breaks another architecture build and has
> only made it to linux-next on July 29 ... and needs more work given the
> comments already on this patch.

It doesn't break another architecture build since only x86 IOMMUs use
the helper function. But as I pointed out, it doesn't work for some
architectures.
