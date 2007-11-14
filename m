Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXKNAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXKNAL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXKNALS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:11:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36201 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbXKNALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:11:17 -0500
Date: Tue, 13 Nov 2007 16:00:30 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Message-ID: <20071114000030.GA30402@kroah.com>
References: <20071015204840.074767068@goop.org> <4713E2D6.90801@goop.org> <20071113232258.GA10338@kroah.com> <200711140053.33584.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711140053.33584.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:53:33AM +0100, Andi Kleen wrote:
> 
> > > Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
> > > upsetting Xen
> 
> This patch was the wrong fix anyways as discussed; David Chinner
> finally came up with a better one.

Ok, that's good to know, if someone wants to send me the correct one,
that would be appreciated.

Although, it's not like anyone actually uses the in-kernel Xen on
2.6.23, so it's probably not really worth it.

thanks,

greg k-h
