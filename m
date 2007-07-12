Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbXGLXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbXGLXby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXGLXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:31:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbXGLXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:31:44 -0400
Date: Thu, 12 Jul 2007 16:31:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>,
       netdev@vger.kernel.org
Subject: Re: [2.6.23 PATCH 13/18] dm: netlink
Message-Id: <20070712163115.ee686f8d.akpm@linux-foundation.org>
In-Reply-To: <20070712231920.GZ11166@waste.org>
References: <20070711210137.GE24114@agk.fab.redhat.com>
	<20070711142712.e646995b.akpm@linux-foundation.org>
	<20070712231920.GZ11166@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 18:19:20 -0500
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
> 

Yes, it would be somewhat sad.  However one can presumably continue to use
DM, just without "DM netlink events".

But that probably means that one will not be able to use the standard DM
admin tools without networking.  Maybe there will remain alternative but
cruder ways to get things done?
