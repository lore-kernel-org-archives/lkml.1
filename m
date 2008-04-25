Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbYDYRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbYDYRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYDYRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:19:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754264AbYDYRTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:19:12 -0400
Date: Fri, 25 Apr 2008 18:12:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
Cc: "'Kathy Frazier'" <kfrazier@daetwyler-rd.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Talking to parallel port in 2.6 kernel without using parport
Message-ID: <20080425181219.61e29b1f@core>
In-Reply-To: <006f01c8a4a7$82e37ea0$88aa7be0$@com>
References: <009501c89e28$3d7530f0$b85f92d0$@com>
	<20080414133937.7080d30d@core>
	<006f01c8a4a7$82e37ea0$88aa7be0$@com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One of our engineers downloaded source code a while back from
> linux-2.6.18-rc7, but I am not sure how close that is to what is installed
> on my system (uname -r returns 2.6.18-1.2798.fc6.  When I set my printk to 8
> (echo 8 > /proc/sys/kernel/printk), there are no messages shown on the
> failure.  According to the source code I have, the only silent failure in
> parport_register_device is:

Nothing immediately strikes me.

> When I change the flags from PARPORT_FLAG_EXCL to 0 in the call to
> parport_register_device, the call returns a non-zero to indicate success.

Do you have the printer driver loaded already ? (and does it behave if
you do rmmod lp first)

> Can you tell me what I am missing?  Where can I get the actual source code
> that goes with this version to further unravel this?

>From the .fc6 it would be an old Fedora kernel so very close to standard
2.6.18 from kernel.org, but the Fedora Core kernels are available from
the Fedora download pages - the .srpm package for each kernel is the one
matching the same binary - so google for "2.6.18-1.2798.fc6.src.rpm"

http://www.mjmwired.net/resources/mjm-fedora-fc6.html has a few notes on
it. 

To be honest this area of the kernel hasn't changed much over recent
times. Let me know if you can't figure out what is going on.
