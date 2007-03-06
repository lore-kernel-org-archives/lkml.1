Return-Path: <linux-kernel-owner+w=401wt.eu-S933920AbXCFDxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbXCFDxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933918AbXCFDxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:53:22 -0500
Received: from waste.org ([66.93.16.53]:60976 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933919AbXCFDxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:53:20 -0500
Date: Mon, 5 Mar 2007 21:39:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070306033947.GQ23311@waste.org>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305234052.GR3441@stusta.de> <20070306000722.GA11436@kroah.com> <20070306013020.GN23311@waste.org> <20070306024850.GA24477@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306024850.GA24477@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 06:48:50PM -0800, Greg KH wrote:
> If so, can you disable the option and strace it to see what program is
> trying to access what?  That will put the
> HAL/NetworkManager/libsysfs/distro script finger pointing to rest pretty
> quickly :)

Ok, I've got straces of both good and bad (>5M each). Filtered out
random pointer values and the like, diffed, and filtered for /sys/,
and the result's still 1.5M. What should I be looking for?

-- 
Mathematics is the supreme nostalgia of our time.
