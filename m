Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbYBLRxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbYBLRxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYBLRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:53:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37558 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbYBLRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:53:22 -0500
Date: Tue, 12 Feb 2008 09:51:09 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device
Message-ID: <20080212175109.GA2114@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org> <20080212164232.GA326@kroah.com> <adak5lavzpf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak5lavzpf.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:42:20AM -0800, Roland Dreier wrote:
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

Great, I'll look into that as I need a test case for this kind of stuff.

thanks,

greg k-h
