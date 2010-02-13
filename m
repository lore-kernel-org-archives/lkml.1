Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0BMRmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 12:42:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0BMRmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 12:42:36 -0500
Date: Sat, 13 Feb 2010 19:39:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] vhost-net: switch to smp barriers
Message-ID: <20100213173911.GA5040@redhat.com>
References: <20100201172101.GA10900@redhat.com> <20100207090749.GA12968@redhat.com> <201002081849.39512.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002081849.39512.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 06:49:39PM +1030, Rusty Russell wrote:
> On Sun, 7 Feb 2010 07:37:49 pm Michael S. Tsirkin wrote:
> > On Mon, Feb 01, 2010 at 07:21:02PM +0200, Michael S. Tsirkin wrote:
> > > vhost-net only uses memory barriers to control SMP effects
> > > (communication with userspace potentially running on a different CPU),
> > > so it should use SMP barriers and not mandatory barriers for memory
> > > access ordering, as suggested by Documentation/memory-barriers.txt
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > 
> > Rusty, any feedback on this one?
> > Thanks!
> 
> Yep.  barrier() is correct on UP to guard against preemption.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Thanks,
> Rusty.

Dave, I see it's marked "not applicable":
http://patchwork.ozlabs.org/patch/44207/
the patch applies to net-next as of
b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73.
Can this be queued up please?
Should I resubmit with Rusty's ack?

Thanks!

-- 
MST
