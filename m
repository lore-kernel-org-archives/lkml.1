Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbXBHR4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbXBHR4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXBHR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:56:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXBHR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:56:09 -0500
Date: Thu, 8 Feb 2007 17:56:02 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Ben Dooks <ben-linux@fluff.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: SM501 core driver
In-Reply-To: <20070207170949.GD21120@fluff.org.uk>
Message-ID: <Pine.LNX.4.64.0702081755290.7686@pentafluge.infradead.org>
References: <20070206192628.GA13644@fluff.org.uk>
 <20070206210930.fc814bf6.akpm@linux-foundation.org> <20070207114825.GA21120@fluff.org.uk>
 <20070207085225.c2371cfd.akpm@linux-foundation.org> <20070207170949.GD21120@fluff.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Do you have a new patch?


> > No, that shuldn't be necessary.  If it was, the compiler would optimise
> > away the first readl() in 
> > 
> > 	my_local = readl(foo);
> > 	my_local = readl(bar);
> > 
> > which would break stuff.  readl() implementations use volatile to prevent
> > this.
> 
> Ok, i've moved these into their own function called
> sm501_sync_regs() to make it more explicit what it is
> being used for.
> 
> 
