Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYDNEXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYDNEXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYDNEXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:23:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58709 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYDNEXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:23:05 -0400
Date: Sun, 13 Apr 2008 21:28:47 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for April 10: generic pci_enable_resources()
	strikes again
Message-ID: <20080414042847.GB24269@kroah.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <200804102134.00997.m.kozlowski@tuxland.pl> <20080414114823.b20802fe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414114823.b20802fe.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:48:23AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 10 Apr 2008 21:34:00 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> >
> > 	The commit b818da52 makes my sparc64 box simply unable to boot.
> > You should probably take a look at other arches as well. The story is here:
> > 
> > http://lkml.org/lkml/2008/3/28/465
> > http://lkml.org/lkml/2008/4/1/248
> 
> This patch has remained unchanged since first imported into linux-next in
> March 6.
> 
> So, the question is: What are the consequences of reverting it?  I am not
> in a position to judge, but if it causes boxes to simply not boot, then
> it would be a major regression in 2.6.26 and simply cannot be included
> there.
> 
> I will revert it at the end of today's tree and hope that there is some
> resolution before the merge window opens.
> 
> Of course, there is still the question of the other architectures ...

Yes, I haven't caught up with my emails, but yes, this will not go
upstream for those arches that have had problems with it (like sparc64).
I'll fix my tree up first thing Monday morning for this issue.

Sorry for taking so long with it, been stuck doing other things...

thanks,

greg k-h
