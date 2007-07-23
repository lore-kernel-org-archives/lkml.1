Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXGWSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXGWSeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764287AbXGWSdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:33:39 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:2459 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763006AbXGWSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:33:38 -0400
Date: Mon, 23 Jul 2007 20:33:36 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Message-ID: <20070723183336.GA3736@roarinelk.homelinux.net>
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de> <20070723084505.GB349@roarinelk.homelinux.net> <46A49244.9010402@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A49244.9010402@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:34:28PM +0200, Stefan Richter wrote:
> Manuel Lauss wrote:
> > I noticed the failures start when there are 2 concurrent disk accesses
> > (copy something from fw disk on shell 1 and it runs fine; start to
> > copy something TO the fw disk on shell 2 and a "management write failed"
> > error appears after 1-2 sec. with the orb timeout after a looong time)
> 
> Most of my tests have been with a single process, but I already tested
> several processes at once in parallel too.  But probably only on the
> bigger machine where neither the CPU nor the PCI bus (and this might be
> important) would become a bottleneck.  I have to test this again on the
> smaller machines.

I think I found a way to reliably reproduce the problem (2.6.22)

NFS-export the fw disk, mount it on another host, put a movie on it,
play it with mplayer on the other machine. Seek a little in the movie,
locks up every time here. If it doesnt, copy data to the disk in parallel.

Thanks,
	Manuel Lauss

