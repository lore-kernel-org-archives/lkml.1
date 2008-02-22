Return-Path: <linux-kernel-owner+w=401wt.eu-S935517AbYBVKCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517AbYBVKCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYBVKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:02:38 -0500
Received: from 1wt.eu ([62.212.114.60]:2076 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935174AbYBVKCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:02:37 -0500
Date: Fri, 22 Feb 2008 11:02:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
Message-ID: <20080222100223.GA4711@1wt.eu>
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu> <47A46BF8.6030306@davidnewall.com> <47BDDD4E.1080000@davidnewall.com> <20080221203640.GA21764@kroah.com> <20080221210058.GA27541@1wt.eu> <20080221213345.GB24191@kroah.com> <47BE267E.3070508@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE267E.3070508@davidnewall.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 12:03:50PM +1030, David Newall wrote:
> Greg KH wrote:
> > On Thu, Feb 21, 2008 at 10:00:58PM +0100, Willy Tarreau wrote:
> >   
> >> I too agree to merge, it especially since it fixed several problems
> >> for David. However, I would like to know first if the same problems
> >> also happen with the 2.6 driver or if it is OK. The risk is getting
> >> 2.4 fixed and not 2.6, which could cause regressions for people upgrading
> >> from 2.4 to 2.6. Of course, a regression on a USB-serial adapter is
> >> not dramatic, but it's a general principle to keep in mind that 2.6
> >> should be safe (or at least actively being fixed) when merging driver
> >> changes in 2.4.
> >>     
> >
> > As far as I can tell, this was a backport of the current 2.6 driver, so
> > it should not have fixes that are not already in 2.6.
> >
> > David, is that true?
> >   
> 
> That is true.

OK that's perfect. I will merge it.

Cheers,
Willy

