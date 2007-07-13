Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbXGMBHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbXGMBHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 21:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbXGMBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 21:07:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531AbXGMBHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 21:07:00 -0400
Date: Fri, 13 Jul 2007 03:06:34 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070713010634.GM28613@v2.random>
References: <20070706222651.GG5777@v2.random> <20070712175308.GW11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712175308.GW11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 12:53:09PM -0500, Matt Mackall wrote:
> On Sat, Jul 07, 2007 at 12:26:51AM +0200, Andrea Arcangeli wrote:
> > The original idea of having a software page size larger than a
> > hardware page size, originated at SUSE by myself and Andi Kleen while
> > helping AMD to design their amd64 cpu,
> 
> Original? This was done on VAXen and in Mach ages ago.

I know nothing about that ancient stuff, but I've to trust you on
this.

> On Linux, there've already been two implementations, one by Hugh
> Dickens and an expanded version by Bill Irwin (presented at OLS in
> 2003).
> 
> Bill's patch was notable for going to heroic efforts to maintain
> binary compatibility, basically separating the userspace notion of the
> ABI's page size from the kernel's. How's your version fair here?

The events I referred to happened well before Bill's effort.

I admit I also started having some doubt about the correctness of my
above statement when I read Hugh's patch dated Jul 2001 in the last
few days, I'm now uncertain when Hugh's effort started, probably many
months before he published his code.

Overall I definitely shooted myself in the foot ;), because 1) I don't
actually care that much about the attribution of the idea (I wrote it
only as a side note), 2) we're in open source intellectual property
destruction land anyway so it doesn't matter who had the
idea. Apologies.

The way I felt while writing that side note, was that the time has
come to do what we had planned a long time ago, I simply didn't care
too much if VAXen or other ancient OS had it working before, sorry.
