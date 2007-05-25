Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbXEYQsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbXEYQsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbXEYQsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:48:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:36240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXEYQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:48:42 -0400
Date: Fri, 25 May 2007 09:48:42 -0700
From: Greg KH <gregkh@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, yi.zhu@intel.com
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070525164842.GA6220@suse.de>
References: <20070525163621.GE11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525163621.GE11166@waste.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 11:36:22AM -0500, Matt Mackall wrote:
> 2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
> matter. Bringing up the interface manually still works, so I suspect
> this is sysfs or HAL related again. Again, Debian unstable so
> userspace is quite up-to-date.

I don't have any driver model changes that affect network devices in my
tree.  Could you go through and bisect the -mm tree to see if you can
find the patch that causes this?

thanks,

greg k-h
