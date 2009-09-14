Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZINQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZINQwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZINQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZINQwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:52:07 -0400
Date: Mon, 14 Sep 2009 19:47:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20090914164750.GB3745@redhat.com>
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu> <4AAA7415.5080204@gmail.com> <20090913120140.GA31218@redhat.com> <4AAE6A97.7090808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAE6A97.7090808@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:08:55PM -0400, Gregory Haskins wrote:
> For Ira's example, the addresses would represent a physical address on
> the PCI boards, and would follow any kind of relevant rules for
> converting a "GPA" to a host accessible address (even if indirectly, via
> a dma controller).

I don't think limiting addresses to PCI physical addresses will work
well.  From what I rememeber, Ira's x86 can not initiate burst
transactions on PCI, and it's the ppc that initiates all DMA.

> 
> >  But we can't let the guest specify physical addresses.
> 
> Agreed.  Neither your proposal nor mine operate this way afaict.

But this seems to be what Ira needs.

> HTH
> 
> Kind Regards,
> -Greg
> 


