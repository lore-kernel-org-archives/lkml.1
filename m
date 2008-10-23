Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYJWTyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYJWTyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYJWTy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:54:28 -0400
Received: from cnc.isely.net ([64.81.146.143]:45031 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbYJWTy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:54:27 -0400
Date: Thu, 23 Oct 2008 14:54:25 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <20081023191543.GA10017@kroah.com>
Message-ID: <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net> <20081020172914.GA9624@kroah.com>
 <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net> <20081023191543.GA10017@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Greg KH wrote:

> On Thu, Oct 23, 2008 at 11:27:11AM -0500, Mike Isely wrote:
> > On Mon, 20 Oct 2008, Greg KH wrote:
> > 

   [...]

> > > 
> > > Will this patch be sent to the -stable group, to fix this regression in
> > > 2.6.27?  Or should they take Alan's fix instead?
> > > 
> > 
> > Greg:
> > 
> > I didn't directly answer your question here because I had figured it was 
> > answered in a previous post on this thread, that Mike Krufky had already 
> > explicitly asked that it be queued (and added his Reviewed-By tag), and 
> > that I figured it best not to add yet more noise to an already noisy 
> > group.
> > 
> > However now I see that this patch didn't get into 2.6.27.3.  It's a 
> > pretty important fix; without it the pvrusb2 driver is worse than 
> > useless (unless one adds initusbreset=0 as a module option).
> 
> As we were discussing this on Monday, and the review cycle for 2.6.27.3
> started last Saturday, it would have been pretty hard to get it into
> 2.6.27.3 :)
> 
> I need to see the patch in Linus's tree first, before it can go into any
> stable release.  Is it in there yet?  If so, please send me the git
> commit id and I'll queue it up for the next -stable round.
> 

OK, I understand.

As far as I know, Linus has not yet pulled the changes from Mauro (part 
of a larger set).  But that information is a few hours old.  I or Mike 
Krufky will let you know if/when one of us finds out.

Thanks for following up.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
