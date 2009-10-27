Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZJ0OAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZJ0OAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZJ0OAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:00:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52082 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbZJ0OAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:00:15 -0400
Date: Tue, 27 Oct 2009 14:00:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: Michael Guntsche <mike@it-loops.com>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091027140018.GF8900@csn.ul.ie>
References: <20091027095014.GA22215@gibson.comsick.at> <200910271138.01624.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200910271138.01624.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 11:38:00AM +0100, Frans Pop wrote:
> Michael Guntsche wrote:
> > I noticed that I get page alloc errors on one of my machines.
> > It is an old server I use as a fileserver with 512MB RAM. Before
> > 2.6.3[12] I did not see this problem at all.
> > This only seems to happens when I use mutt on this machine.
> > I know that it means I am running out of memory here, but I am wondering
> > why I did not see this before....
> > 
> > mutt: page allocation failure. order:1, mode:0x20
> > Pid: 21746, comm: mutt Not tainted 2.6.32-rc5 #2
> 
> This is a known issue that's being heavily investigated, but is proving 
> very elusive. See http://lkml.org/lkml/2009/10/22/128 for an overview.
> 
> Can you easily reproduce the problem, or does it happen at random moments? 
> If you can reproduce it, it would be great if you could test the patches 
> mentioned in that mail.
> 

Specifically, this looks very like the bug

"page allocation failure message kernel 2.6.31.4 (tty-related)"

The first three patches on the thread Frans Pop are expected to close
that one out. Michael, I'm hoping they'll help you too. Whether they
help or not, let me know please.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
