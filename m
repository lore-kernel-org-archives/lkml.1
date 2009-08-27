Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZH0J7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZH0J7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZH0J7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:59:25 -0400
Received: from ozlabs.org ([203.10.76.45]:50007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbZH0J7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:59:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 27 Aug 2009 19:29:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
References: <cover.1250693417.git.mst@redhat.com> <20090825131634.GA13949@redhat.com> <20090826165655.GA23632@redhat.com>
In-Reply-To: <20090826165655.GA23632@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908271929.23454.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 02:26:55 am Michael S. Tsirkin wrote:
> On Tue, Aug 25, 2009 at 04:16:34PM +0300, Michael S. Tsirkin wrote:
> > > > +	/* If they don't want an interrupt, don't send one, unless empty. */
> > > > +	if ((flags & VRING_AVAIL_F_NO_INTERRUPT) && vq->inflight)
> > > > +		return;
> > > 
> > > And I wouldn't support notify on empty at all, TBH.
> > 
> > If I don't, virtio net in guest uses a timer, which might be expensive.
> > Will need to check what this does.
> > 
> > >  It should
> > > definitely be conditional on the guest accepting the NOTIFY_ON_EMPTY
> > > feature.
> 
> lguest does not do it this way though, do it?

Does when a patch in my current queue is applied though.

Thanks,
Rusty.
