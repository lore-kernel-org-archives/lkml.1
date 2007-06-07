Return-Path: <linux-kernel-owner+w=401wt.eu-S1764618AbXFGP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764618AbXFGP7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbXFGP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:59:42 -0400
Received: from waste.org ([66.93.16.53]:37331 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbXFGP7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:59:41 -0400
Date: Thu, 7 Jun 2007 10:59:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607155913.GW11115@waste.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org> <20070607022608.GA2416@localhost.localdomain> <20070607055912.GX11166@waste.org> <20070607065158.GA1996@localhost.localdomain> <20070607140444.GR11115@waste.org> <20070607154007.GA9305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607154007.GA9305@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:40:08PM +0800, WANG Cong wrote:
> On Thu, Jun 07, 2007 at 09:04:44AM -0500, Matt Mackall wrote:
> >On Thu, Jun 07, 2007 at 02:51:58PM +0800, WANG Cong wrote:
> >> >> Maybe there's something wrong with ketchup. ;(
> >> >
> >> >Can you do an 'lsdiff | grep lguest' on the patch in your ~/.ketchup directory?
> >> >
> >> >Ketchup simply applies patches, it never touches filenames directly.
> >> >So for something to go wrong here and drop a file in the tree with a
> >> >damaged pathname, you've either got a damaged patch, a bug in patch
> >> >itself, or some form of filesystem corruption.
> >> 
> >> Thanks for your point.
> >> 
> >> It should be Documentation/lguest/lguest.c, maybe it was corrupted and ketchup
> >> backuped it as mlguest.c.
> >
> >It'd be interesting to figure out how that happened, still.
> >
> >If your patch file is intact (are you using GPG's signature-checking
> >support?), the most likely explanation is an operating system or
> >filesystem bug.
> 
> Yes, I am using GPG's checking.

Well that gives a pretty solid assurance that the patch you downloaded
matches the one on kernel.org. And that one doesn't contain an
mlguest.c. 

Ketchup doesn't even look inside patches, and patch doesn't invent
names, so something in the bzip2 -> patch(1) -> filesystem chain got
corrupted. Probably not bzip2, as it has CRCs.

Do you have ECC memory?

-- 
Mathematics is the supreme nostalgia of our time.
