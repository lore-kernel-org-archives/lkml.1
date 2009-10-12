Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbZJLWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbZJLWIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933362AbZJLWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:08:08 -0400
Received: from kroah.org ([198.145.64.141]:45204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352AbZJLWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:08:07 -0400
Date: Mon, 12 Oct 2009 15:04:45 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: Fred.L.Templin@boeing.com, contact@saschahlusiak.de,
       yoshfuji@linux-ipv6.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 37/37] sit: fix off-by-one in
 ipip6_tunnel_get_prl
Message-ID: <20091012220445.GB31010@kroah.com>
References: <20091009233411.852013234@mini.kroah.org>
 <20091009233440.786680001@mini.kroah.org>
 <12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
 <20091009.204231.204042155.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009.204231.204042155.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 08:42:31PM -0700, David Miller wrote:
> From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
> Date: Fri, 9 Oct 2009 17:34:49 -0700
> 
> > Wait a moment - I remember now that this code came
> > from Yoshifuji, and I believe there was a reason for
> > the cmax+1. The application is expected to know this
> > and to post a large enough buffer.
> > 
> > Can we put this on hold until I have had a chance to
> > check my e-mail archives and my local iproute changes
> > (will respond on monday)?
> 
> Sure, we can keep it out of -stable for now.
> 
> But it is in Linus's tree so if you find we shouldn't do this
> you'll need to send me a revert for net-2.6
> 
> Otherwise if it's good, you'll have to remind me to resubmit
> it to -stable.

Ah crap, I just commited it.

Is it really broken?  If so, I'll go revert it and cut a new release.

Sorry about this.

greg k-h
