Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0BHITr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:19:47 -0500
Received: from ozlabs.org ([203.10.76.45]:38592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0BHITo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:19:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost-net: switch to smp barriers
Date: Mon, 8 Feb 2010 18:49:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20100201172101.GA10900@redhat.com> <20100207090749.GA12968@redhat.com>
In-Reply-To: <20100207090749.GA12968@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081849.39512.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Feb 2010 07:37:49 pm Michael S. Tsirkin wrote:
> On Mon, Feb 01, 2010 at 07:21:02PM +0200, Michael S. Tsirkin wrote:
> > vhost-net only uses memory barriers to control SMP effects
> > (communication with userspace potentially running on a different CPU),
> > so it should use SMP barriers and not mandatory barriers for memory
> > access ordering, as suggested by Documentation/memory-barriers.txt
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 
> Rusty, any feedback on this one?
> Thanks!

Yep.  barrier() is correct on UP to guard against preemption.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
