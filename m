Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbXKHU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbXKHU3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbXKHU3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:29:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60891 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760887AbXKHU3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:29:39 -0500
Date: Thu, 8 Nov 2007 20:29:37 +0000
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Plans for Onezonelist patch series ???
Message-ID: <20071108202936.GG23882@skynet.ie>
References: <20071107011130.382244340@sgi.com> <1194535612.6214.9.camel@localhost> <1194537674.5295.8.camel@localhost> <Pine.LNX.4.64.0711081033570.7871@schroedinger.engr.sgi.com> <20071108184009.GC23882@skynet.ie> <Pine.LNX.4.64.0711081043420.7871@schroedinger.engr.sgi.com> <20071108200607.GD23882@skynet.ie> <Pine.LNX.4.64.0711081218250.10074@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711081218250.10074@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/11/07 12:20), Christoph Lameter didst pronounce:
> On Thu, 8 Nov 2007, Mel Gorman wrote:
> 
> > I've rebased the patches to mm-broken-out-2007-11-06-02-32. However, the
> > vanilla -mm and the one with onezonelist applied are locking up in the
> > same manner. I'm way too behind at the moment to guess if it is a new bug
> > or reported already. At best, I can say the patches are not making things
> > any worse :) I'll go through the archives in the morning and do a bit more
> > testing to see what happens.
> 
> I usually base my patches on Linus' tree as long as there is no tree 
> available from Andrew. But that means that may have to 
> approximate what is in there by adding this and that.
> 

Unfortunately for me, there are several collisions with the patches when
applied against -mm if the patches are based on latest git. They are mainly in
mm/vmscan.c due to the memory controller work. For the purposes of testing and
merging, it makes more sense for me to work against -mm as much as possible.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
