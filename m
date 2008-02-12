Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbYBLSJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbYBLSJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYBLSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:08:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58889 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbYBLSIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:08:49 -0500
Message-ID: <47B1E0AE.6060806@garzik.org>
Date: Tue, 12 Feb 2008 13:08:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>	<20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org>	<20080212164232.GA326@kroah.com> <adak5lavzpf.fsf@cisco.com>
In-Reply-To: <adak5lavzpf.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > The work I'm doing here is for stupid PCI firmware engineers, who have
>  > created devices that are different things, all bound up under the same
>  > PCI device.  I'm thinking of watchdog timers and random number
>  > generator and i2c controller on the same PCI device, or even the more
>  > basic, frame buffer and DRM access to the same PCI video device.
>  > 
>  > The OLPC is a good example of hardware that needs this kind of
>  > functionality.
> 
> Sounds interesting.  I've been meaning to work on this too for quite a
> while, but I'm glad to see you beat me to it.
> 
> An example of an in-tree use case for this would be the mlx4 drivers--
> you can look at drivers/net/mlx4/intf.c to see the simple stupid
> solution I came up with to allow an IB and a NIC (not yet upstream)
> driver to share the same PCI device.  A good test for your stuff would
> be if it simplifies the code from the ad hoc solution I came up with.

Our APIs are written such that the PCI device probe function is the 
starting point for registering IB and NIC.  No need for anything new.

	Jeff



