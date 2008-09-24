Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYIXNNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYIXNNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYIXNNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:13:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:37050 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYIXNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:13:12 -0400
Date: Wed, 24 Sep 2008 22:12:48 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922183414.GI24392@amd.com>
References: <20080922162314.GC24392@amd.com>
	<20080923015059M.fujita.tomonori@lab.ntt.co.jp>
	<20080922183414.GI24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080924221144W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 20:34:14 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Sep 23, 2008 at 01:51:05AM +0900, FUJITA Tomonori wrote:
> > The patch that I sent doesn't make any changes for you. GART works as
> > before and AMD IOMMU takes a new parameter, fullflush, as you want. It
> > does the exact same thing that the first version of your patchset for
> > 2.6.28.
> > 
> > So please let me apply it then we can stop this discussion.
> 
> Ok, so it was not nice from me to let Ingo pull this patch without your
> ack, I already admitted.

I didn't ask you to try to get my ACK before pushing the patches that
affect all the IOMMUs. I'll never ask for such.

I asked you to get the ACKs from the IOMMUs maintainers that your
patches affect.

If the IOMMUs maintainers who your patch affects agree on your patch,
I will not be against it even if I don't like it.

This time, you tried to add a generic parameter that would be useful
for VT-d, but seems that the VT-d maintainer is not ready for such
decision. Thus, I think that postponing adding the parameter was a
reasonable decision for everyone.

I also insisted that we need serious consideration about how all the
generic parameters interact with each other before changing them, but
again, if all the IOMMUs maintainers agree on a different plan, it's
fine by me.


> To end this discussion and get to productive
> discussions, Ingo, please apply this patch. I hope we will work together
> on a final solution for the problem.

Thanks very much.
