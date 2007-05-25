Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXEYXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXEYXNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXEYXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:13:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:41969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXEYXNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:13:13 -0400
Date: Fri, 25 May 2007 16:12:57 -0700
From: Greg KH <gregkh@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070525231257.GA9616@suse.de>
References: <20070525163621.GE11166@waste.org> <20070525164842.GA6220@suse.de> <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com> <20070525175319.GK11115@waste.org> <20070525210152.GL11115@waste.org> <20070525230109.GN11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525230109.GN11115@waste.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 06:01:09PM -0500, Matt Mackall wrote:
> Bisect sequence went 56+ 84+ 98+ 105- 102- 100+ 101+. Looks like 102's
> to blame:
> 
> driver-core-check-return-code-of-sysfs_create_link.patch 
> 
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> Check for return value of sysfs_create_link() in device_add() and
> device_rename().  Add helper functions device_add_class_symlinks() and
> device_remove_class_symlinks() to make the code easier to read.

{sigh}

This wouldn't be the first time this patch has broken things :(

Andrew, can you drop this from your tree?

Cornelia, can you rework this to not break things?

thanks,

greg k-h
