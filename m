Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXCFDSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXCFDSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933899AbXCFDSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:18:00 -0500
Received: from waste.org ([66.93.16.53]:39844 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896AbXCFDR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:17:59 -0500
Date: Mon, 5 Mar 2007 21:04:52 -0600
From: Matt Mackall <mpm@selenic.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070306030452.GO23311@waste.org>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305234052.GR3441@stusta.de> <20070306000722.GA11436@kroah.com> <20070306013020.GN23311@waste.org> <20070306024850.GA24477@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306024850.GA24477@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 06:48:50PM -0800, Greg KH wrote:
 
> Wait, have confirmed that if you enable this config option,
> NetworkManager starts back up again and works properly?

Yep, probably should have mentioned that.

> If so, can you disable the option and strace it to see what program is
> trying to access what?  That will put the
> HAL/NetworkManager/libsysfs/distro script finger pointing to rest pretty
> quickly :)

Did that a few hours ago, got a very large dump from both programs. No
smoking guns to my eye, but I'll send you the logs later.

-- 
Mathematics is the supreme nostalgia of our time.
