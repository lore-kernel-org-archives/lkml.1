Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYDGRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYDGRyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYDGRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:54:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:58189 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYDGRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:54:34 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/5] vringfd syscall 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sat, 05 Apr 2008 22:02:08 +1000."
             <200804052202.09157.rusty@rustcorp.com.au> 
Date: Mon, 07 Apr 2008 11:54:34 -0600
Message-ID: <12555.1207590874@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Rusty,

> For virtualization, we've developed virtio_ring for efficient communication.
> This would also work well for userspace-kernel communication, particularly
> for things like the tun device.  By using the same ABI, we can join guests
> to the host kernel trivially.

I'm *sure* you meant to document that somewhat non-trivial proposed new
kernel API as soon as you got a moment.  But, since I went to the
trouble of reverse engineering it, I decided not to wait and to make a
little unreliable guide of my own.  For those who are curious about how
vringfd() is meant to work (or about how badly I misunderstood it), the
info is at:

	http://lwn.net/SubscriberLink/276856/8c927025c53ad7ce/

Hopefully it will be helpful,

jon
