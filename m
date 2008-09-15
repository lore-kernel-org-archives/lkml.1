Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYIOVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYIOVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYIOVZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:25:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37085 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYIOVZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:25:00 -0400
Date: Mon, 15 Sep 2008 17:24:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080915212459.GE3994@havoc.gtf.org>
References: <20080915.120917.36004302.davem@davemloft.net> <20080915201749.GB3994@havoc.gtf.org> <20080915.132716.267218808.davem@davemloft.net> <20080915.141159.181213705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915.141159.181213705.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 02:11:59PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 15 Sep 2008 13:27:16 -0700 (PDT)
> 
> > I'll take another look at the queue and try to give you some
> > more specific feedback.
> 
> 	Thomas Bogendoerfer (1):
> 	      tulip: Fix dead 21041 ethernet after ifconfig down
> 
> Not a regression, that problem has been there forever.

> 	Hannes Hering (1):
> 	      ehea: Fix DLPAR memory handling
> 
> No kernel bugzilla, no regression list entry, no way.
> 
> 	Krzysztof Halasa (1):
> 	      wan/hdlc_x25.c: fix a NULL dereference
> 
> Not a 2.6.27 regression, this problem has been there forever.

> So, as I said, the vast majority of this stuff is absolulte not
> appropriate.  Most of it can totally wait for 2.6.28, and not
> be merged now.
> 
> You can accelerate this process by making sure that every
> commit message has a reference to the regression list entry
> or a kernel bugzilla that the patch fixes.

So, my takeaway from this is...

1) Creating a bugzilla entry magically makes a bug fix acceptable?

2) We no longer want "this kills the driver" fixes?

I disagree with that logic, and I seriously doubt Linus wants to turn
away serious fixes to serious problems.  Many of these are clearly
needed, just read the extended patch description and the patch itself.

You just rejected patches that (a) fixed dead ethernet [de2104x], (b) fixed an
oops [WAN], and (c) fixed memory corruption [ehea].

I feel like I have just stepped into Odd World, if you don't want fixes
as serious as these.

	Jeff



