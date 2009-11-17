Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKQNZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKQNZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZKQNZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:25:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48311 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZKQNZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:25:34 -0500
Date: Tue, 17 Nov 2009 13:25:37 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
	without CONFIG_XICS set
Message-ID: <20091117132537.GA29804@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie> <1258461544.24093.72.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1258461544.24093.72.camel@concordia>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:39:04PM +1100, Michael Ellerman wrote:
> On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> > KConfig doesn't require CONFIG_XICS to be set with CONFIG_PSERIES but if
> > it's not set, there are numerous small build errors. This is a small series
> > of patches to allow CONFIG_XICS to be unset in the config.
> > 
> > XICS appears to be some sort of interrupt controller but I'm not sure how
> > common it is on systems that require CONFIG_PSERIES. If CONFIG_PSERIES
> > universally requires CONFIG_XICS, the better path might be to force it to
> > be set.
> 
> It is indeed 'some sort of interrupt controller' :)
> 
> All the virtualised PSERIES systems have, or appear to have, a XICS. So
> it's pretty common.
> 
> I think the only time you see an MPIC is on older machines, and even
> then maybe only if you're running bare metal.
> 
> So it is pretty much required for a PSERIES kernel, but perhaps there
> are cases where the BML guys want to be able to turn it off.
> 

Do you want to take ownership of the series as I'm a bit unclear on how
and when XICS should be used? If not, I don't mind fixing the series up
as you suggested but I wouldn't be in the best position to determine if
the final result is sensible or not.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
