Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbXFXIlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbXFXIlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 04:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXFXIlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 04:41:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53431 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbXFXIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 04:41:16 -0400
Date: Sun, 24 Jun 2007 00:06:02 -0700
From: Greg KH <greg@kroah.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Adrian Bunk" <bunk@stusta.de>, "david@lang.hm" <david@lang.hm>,
       "David Miller" <davem@davemloft.net>,
       "bunk@stusta.de; Duncan Sands" <duncan.sands@math.u-psud.fr>,
       "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
	control
Message-ID: <20070624070601.GB24941@kroah.com>
References: <1182373258.30574.30.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182373258.30574.30.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 09:00:58PM +0000, Huang, Ying wrote:
> Hi,
> 
> This is a new version of multithreaded probing patch, with more
> parallelism control added.
> 
> There are more control over which devices and drivers will be probed
> parallelized or serially. For example, in IEEE1394 subsystem, the
> different "units" in one "node" can be probed serially while the
> different "nodes" can be probed parallelized.
> 
> The number of threads can be controlled through a kernel command line
> parameters.
> 
> The patch is against 2.6.22-rc5. The "wait_for_probes" function in the
> patch comes from the original multithreaded probing patch. If I need do
> anything because of it, please let me know.
> 
> Any comment is welcome.

I'm still not convinced that we need to add this kind of complexity to
the driver core, instead of just letting the individual driver
subsystems do this, if they want to do it.

Especially as no subsystem wants to do this today :)

thanks,

greg k-h
