Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZIIICu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZIIICu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZIIICt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:02:49 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47587 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZIIICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:02:48 -0400
Date: Wed, 9 Sep 2009 10:02:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johan van Baarlen <JF@vanbaarlen.demon.nl>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090909100247.2acaceff@skybase>
In-Reply-To: <20090908225858.04d56dce.akpm@linux-foundation.org>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
	<20090908225858.04d56dce.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 22:58:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Aug 2009 13:18:08 +0100 (BST) Michael Abbott <michael@araneidae.co.uk> wrote:
> 
> > Reviving this:
> > 
> > On Sat, 9 May 2009, Jan Engelhardt wrote:
> > > starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
> > > the second field of /proc/uptime always shows 0.00. This happens for
> > > both the typical i386 (my case) and on an ARM (according to Michael,
> > > cc'ed).
> > > 
> > > >From the commit log of 79741dd:
> > > 
> > > 	"""The cpu time spent by the idle process actually doing
> > > 	something is currently accounted as idle time. This is plain
> > > 	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
> > > 	can do better: distinguish between the time spent doing
> > > 	nothing and the time spent by idle doing work. The first is
> > > 	accounted with account_idle_time and the second with
> > > 	account_system_time."""
> > > 
> > > Citing Michael from our irc conversation:
> > > 
> > > 	"""the writer[committer] [says] that [the] idle process time
> > > 	isn't really idle time ... but that's all that /proc/uptime
> > > 	looks at. I guess fs/proc/uptime.c needs to catch up."""
> > > 
> > > So, were the updates to uptime.c missed, or do we now live on with
> > > /proc/uptime constantly having 0?
> > 
> > My previous patch seems to have run into the sand.  It every so nearly got 
> > pulled into mainstream as far as I can tell, but didn't seem to make it; 
> > no idea what happened.
> > 
> > So here we go again:
> > 
> 
> Imagine my surprise to find a version of this patch lurking in Martin's
> tree since June 22.  It's a regression fix!
> 
> Johan, does this patch help with the regression you reported in
> http://bugzilla.kernel.org/show_bug.cgi?id=14131 ?

I did send a Please-Pull for the cputime branch back in May. Seems like it
never has been pulled. I don't know why, so perhaps I should just retry. 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

