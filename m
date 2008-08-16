Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYHPX4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYHPX4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYHPX4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:56:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYHPX4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:56:40 -0400
Date: Sat, 16 Aug 2008 16:32:49 -0700
From: Greg KH <greg@kroah.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, stable@kernel.org,
       linux-wireless@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] Fixing rt2500pci [PATCH]
Message-ID: <20080816233249.GA9714@kroah.com>
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <200807302115.03865.IvDoorn@gmail.com> <87vdym6fct.wl%peterc@chubb.wattle.id.au> <200808121201.26544.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808121201.26544.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 12:01:26PM +0200, Ivo van Doorn wrote:
> On Thursday 31 July 2008, Peter Chubb wrote:
> > 
> > In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> > released 2.6.26, my RaLink rt2500 card wouldn't associate.
> > 
> > Git-bisect led me to this patch:
> > 
> > 	61486e0f68d1f8966c09b734566a187d42d65c54
> > 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> > 
> > I believe that there is a problem with that patch --- it
> > (inadvertantly) removes an extra line of code, that used to set the
> > DATABYTE_COUNT field.
> >  
> > This patch reinstates that line, and with it my card works again.
> >  
> > Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> [stable@kernel.org added to CC]
> 
> The 2.6.27 version of the patch has already been pushed upstream,
> this one is for 2.6.26-stable since this fixes a regression introduced after 2.6.25.

Are you sure?  Looking at 2.6.26, the code in that function looks like
it is properly setting the TXD_W0_DATABYTE_COUNT, field.

If it's really a problem, can you send stable@kernel.org a patch that
applies to 2.6.26.2?

thanks,

greg k-h
