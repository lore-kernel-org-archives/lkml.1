Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXBWWSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXBWWSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933246AbXBWWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:18:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbXBWWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:18:08 -0500
Date: Fri, 23 Feb 2007 22:16:57 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jon Maloy <jon.maloy@ericsson.com>, per.liden@ericsson.com,
       allan.stephens@windriver.com, netdev@vger.kernel.org,
       tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tipc-discussion] [RFC: 2.6 patch] net/tipc/: possible cleanups
Message-ID: <20070223221657.GA10153@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@stusta.de>, Jon Maloy <jon.maloy@ericsson.com>,
	per.liden@ericsson.com, allan.stephens@windriver.com,
	netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20070124225850.GU17836@stusta.de> <45B8D5E8.1090308@ericsson.com> <20070223180612.GE12392@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223180612.GE12392@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 07:06:12PM +0100, Adrian Bunk wrote:
> > >My impression is that most of this might have users that are not yet 
> > >submitted for inclusion in the kernel - one year after TIPC was merged.
> > > 
> > >
> > Not quite. The exported symbols belong to a public API for driver 
> > programmers.
> > We know about several users of this API, and there will be more, but I 
> > don't think
> > any of them are aspiring to have their code be included in the kernel.
> >...
> 
> Why not?
> 
> The goal is to get as many drivers as possible included in the kernel.

If we don't have any planned in-tree users for tipc we should simply drop
tipc from the kernel entirely.  No point to make our maintaince work harder
for out of tree freeloaders.
