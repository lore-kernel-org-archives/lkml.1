Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbYJJPxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbYJJPxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYJJPxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:53:16 -0400
Received: from kroah.org ([198.145.64.141]:53784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757858AbYJJPxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:53:15 -0400
Date: Fri, 10 Oct 2008 08:49:46 -0700
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, stable@kernel.org
Subject: Re: [stable] splice vs O_APPEND
Message-ID: <20081010154946.GB20231@kroah.com>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org> <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org> <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org> <E1KoEZM-0007Fb-5i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KoEZM-0007Fb-5i@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:46:00AM +0200, Miklos Szeredi wrote:
> On Thu, 9 Oct 2008, Linus Torvalds wrote:
> > On Thu, 9 Oct 2008, Miklos Szeredi wrote:
> > > 
> > > The thing is, the append-only attribute is absolutely useless without
> > > being able to depend on it.  So in that sense I think the IS_APPEND
> > > issue is important, and I'm fine with your original proposal for that
> > > (except we don't need the IS_IMMUTABLE check).
> > 
> > Heh. In the meantime, I had grown to hate that more complex patch.
> > 
> > So because I do see your point with IS_APPEND (being different from 
> > O_APPEND), but because I also think that O_APPEND itself is a gray and 
> > murky area, I just committed the following. I doubt anybody will ever even 
> > notice it, but while I think it's all debatable, we might as well debate 
> > it with this in place. I do agree that it's "safer" behaviour.
> 
> Thanks.
> 
> I suspect this qualifies for stable kernels too.  Stable team, can you
> please add this to your queue?

Queue for which kernel releases?  .25, .26, and/or .27?

thanks,

greg k-h
