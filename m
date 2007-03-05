Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXCEBSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXCEBSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXCEBSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:18:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:39497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXCEBSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:18:10 -0500
Date: Sun, 4 Mar 2007 17:17:29 -0800
From: Greg KH <greg@kroah.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-ID: <20070305011729.GB7681@kroah.com>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305002550.GI23311@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 06:25:50PM -0600, Matt Mackall wrote:
> On Mon, Mar 05, 2007 at 12:39:24AM +0100, Johannes Berg wrote:
> > [adding linux-wireless to CC]
> > 
> > On Sun, 2007-03-04 at 16:08 -0600, Matt Mackall wrote:
> > > Recent kernels are having troubles with wireless for me. Two seemingly
> > > related problems:
> > 
> > I don't think they are related actually.
> > 
> > > a) NetworkManager seems oblivious to the existence of my IPW2200
> > 
> > This is due to the recent sysfs restructuring I think. IIRC the fix is
> > to upgrade hal to a current git version.
> 
> If that's the cause, the fix is to back out whatever was done to break
> userspace. Breaking userspace is not ok. Upgrading from 2.6.x to
> 2.6.x+1 should not entail replacing substantial parts of userspace,
> especially with NOT-EVEN-FRAKKING-RELEASED-YET CODE. 

I should not have broken any userspace if CONFIG_SYSFS_DEPRECATED is
enabled with that patch.  If that is enabled, and that patch still
causes problems, please let me know.

thanks,

greg k-h
