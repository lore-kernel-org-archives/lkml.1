Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXEAI4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXEAI4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXEAI4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:56:49 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4326 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbXEAI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:56:48 -0400
Date: Tue, 1 May 2007 09:56:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070501085639.GA18233@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pcmcia@lists.infradead.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501084623.GB14364@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:46:23AM +0100, Christoph Hellwig wrote:
> >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> 
> ...
> 
> > Dominik is busy.  Will probably re-review and send these direct to Linus.
> 
> The patch above is the removal of cardmgr support.  While I'd love to
> see this cruft gone it definitively needs maintainer judgement on whether
> they time has come that no one relies on cardmgr anymore.

And I still run and use a platform where the GUI issues cardmgr ioctls.
A recent kernel upgrade (from 2.6.9ish to something more recent) broke
the "eject" GUI button applet due to the fscking with the cardmgr ioctls,
and it thinks the wireless card is always plugged in (and therefore the
signal strength meter remains.)

With all the ioctls gone I'll probably loose the signal strength meter.

And no, I don't have the resources (read: code) to fix and rebuild
userspace since I didn't snarf them when the CVS server was alive a
few years back.

That's the problem with API changes - things always break.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
