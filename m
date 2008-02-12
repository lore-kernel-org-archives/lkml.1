Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbYBLXXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbYBLXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYBLXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:23:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40523 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYBLXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:23:17 -0500
Date: Tue, 12 Feb 2008 15:27:08 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       jeff@garzik.org, davem@davemloft.net, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212232708.GC8295@kroah.com>
References: <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212194100.GH27894@ZenIV.linux.org.uk> <20080212215152.1470fe7f@core> <20080212141726.1e214729.akpm@linux-foundation.org> <20080212222044.214ad821@core> <20080212224103.GK27894@ZenIV.linux.org.uk> <20080212230132.2ea5befd@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212230132.2ea5befd@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:01:32PM +0000, Alan Cox wrote:
> > Hrm...  How badly is pl2303 broken?  I actually use that sucker, so if
> > it needs help - count me in.
> 
> 2303 is pretty good (in fact by usb serial standards outstanding). It has
> all the internal locking needed for now and right down to killing
> lock_kernel entirely outside of open/close (which is going to hit
> everything).
> 
> Only fixme I have tagged for it is
> 
> - if you set an unsupported baud rate it reports it set rather than the
> one you got
> 
> Which is a trivial mend for someone who has suitable docs (its marked
> FIXME: at the right spot)

I'll see what I can do about fixing this.

thanks,

greg k-h
