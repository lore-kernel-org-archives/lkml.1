Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbXGLXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbXGLXqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbXGLXp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:45:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57288 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbXGLXp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:45:57 -0400
Date: Thu, 12 Jul 2007 16:45:42 -0700
From: Mike Anderson <andmike@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6.23 PATCH 13/18] dm: netlink
Message-ID: <20070712234542.GD4768@us.ibm.com>
References: <20070711210137.GE24114@agk.fab.redhat.com> <20070711142712.e646995b.akpm@linux-foundation.org> <20070712231920.GZ11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712231920.GZ11166@waste.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> wrote:
> On Wed, Jul 11, 2007 at 02:27:12PM -0700, Andrew Morton wrote:
> > On Wed, 11 Jul 2007 22:01:37 +0100
> > Alasdair G Kergon <agk@redhat.com> wrote:
> > 
> > > From: Mike Anderson <andmike@us.ibm.com>
> > > 
> > > This patch adds a dm-netlink skeleton support to the Makefile, and the dm
> > > directory.
> > > 
> > > ...
> > >  
> > > +config DM_NETLINK
> > > +	bool "DM netlink events (EXPERIMENTAL)"
> > > +	depends on BLK_DEV_DM && EXPERIMENTAL
> > > +	---help---
> > > +	Generate netlink events for DM events.
> > 
> > Need a dependency on NET there?
> 
> It's really sad to make DM dependent on the network layer.

It wouldn't be all of dm. Only the netlink based event interface would be
dependent.

-andmike
--
Michael Anderson
andmike@us.ibm.com
