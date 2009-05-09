Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZEINxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZEINxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZEINxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:53:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:57018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZEINxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:53:23 -0400
Date: Sat, 9 May 2009 06:46:26 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: Silent meaningless error message
Message-ID: <20090509134626.GC16832@suse.de>
References: <20090501145151.5f97456e@hyperion.delvare> <20090501151435.GB16106@suse.de> <20090509152514.6f2207bc@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509152514.6f2207bc@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 03:25:14PM +0200, Jean Delvare wrote:
> Hi Greg,
> 
> On Fri, 1 May 2009 08:14:35 -0700, Greg KH wrote:
> > On Fri, May 01, 2009 at 02:51:51PM +0200, Jean Delvare wrote:
> > > I see the following error message in my kernel logs:
> > > 
> > > w83627ehf.2576: use which platform_data?
> > > 
> > > This is caused by platform_device_add_data() setting both
> > > pdev->platform_data and pdev->dev.platform_data, and then
> > > platform_device_add() complaining if both pointers are set.
> > > 
> > 
> > The patch that causes this is about to be reverted later today (it's
> > already reverted in my trees), as it was the wrong thing to do, as you
> > point out.
> > 
> > So this should be solved soon, no need for your patch.
> 
> Any news on this? I can't see any fix in kernel 2.6.30-rc5.

It was sent to Linus about 8 hours ago, right after 2.6.30-rc5 came out.
See the patches on lkml if you are interested.

thanks,

greg k-h
