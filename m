Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbZEAXLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbZEAXLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZEAXLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:11:23 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:21655 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZEAXLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:11:22 -0400
X-IronPort-AV: E=Sophos;i="4.40,280,1238976000"; 
   d="scan'208";a="179832178"
Date: Fri, 1 May 2009 16:11:22 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@cuplxvomd02.corp.sa.net,
       netdev@cuplxvomd02.corp.sa.net
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
	devices, v4 (resend)
Message-ID: <20090501231122.GA12797@cuplxvomd02.corp.sa.net>
References: <20090430140559.a2343f7c.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org> <20090430145412.c1386cb2.akpm@linux-foundation.org> <20090501165803.GA13342@cuplxvomd02.corp.sa.net> <20090501132258.672002ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501132258.672002ee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:22:58PM -0700, Andrew Morton wrote:
> On Fri, 1 May 2009 09:58:03 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
> > Yes, we do need a good name, so we are now guaranteed to be entering
> > the Bike Shed Zone.
> 
> Getting the name right is important!  We live with the decision daily,
> for years.

Please don't misunderstand; I was agreeing that we need a *good* name! And
making the (intended to be humorous) comment about bike shedding.

> > I've avoided making any guarantees about this, but /sbin/init is implicitly
> > the red line. If we make this explicit, we're probably back in the vicinity
> > of the bike shed, but this should help frame any subsequent discussion
> > in a concrete manner.
> 
> Well, decisions which are made here can make the difference between
> "computer boots" and "computer doesn't boot".  That ain't bikeshed
> painting.

Again, I agree on the importance of this. At the same time, we risk
kickstarting an abstract and long-winded philosophical discourse on what
the "right" choice is. It does seem as though these usually do yield,
as a minimum, a better understanding of what we're doing, and I am all
in favor of that.

David VomLehn
