Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbZHQRnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbZHQRnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbZHQRnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:43:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52669 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZHQRna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:43:30 -0400
Date: Mon, 17 Aug 2009 20:41:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090817174142.GA11140@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8965E0.8050608@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 10:14:56AM -0400, Gregory Haskins wrote:
> Case in point: Take an upstream kernel and you can modprobe the
> vbus-pcibridge in and virtio devices will work over that transport
> unmodified.
> 
> See http://lkml.org/lkml/2009/8/6/244 for details.

The modprobe you are talking about would need
to be done in guest kernel, correct?

> OTOH, Michael's patch is purely targeted at improving virtio-net on kvm,
> and its likewise constrained by various limitations of that decision
> (such as its reliance of the PCI model, and the kvm memory scheme).

vhost is actually not related to PCI in any way. It simply leaves all
setup for userspace to do.  And the memory scheme was intentionally
separated from kvm so that it can easily support e.g. lguest.

-- 
MST
