Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbYBHSnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbYBHSnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759360AbYBHSmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:42:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:59553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYBHSmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:42:52 -0500
Date: Fri, 8 Feb 2008 10:47:15 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bruno Redondi <bruno.redondi@altarisoluzione.com>
Subject: Re: [patch 13/45] USB: sierra: add support for Onda
	H600/ZteMF330datacard to USB Driver for Sierra Wireless
Message-ID: <20080208184715.GA11296@suse.de>
References: <20080207204118.202098927@mini.kroah.org> <20080207204708.GN16389@suse.de> <3415E2A2AB26944B9159CDB22001004D023D61F1@nestea.sierrawireless.local> <20080208041116.GA8122@suse.de> <3415E2A2AB26944B9159CDB22001004D023D627A@nestea.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D023D627A@nestea.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:50:20AM -0800, Kevin Lloyd wrote:
> > For now, yes, we should mirror what is going to be in the 2.6.25
> kernel
> > release.  I see the split happening for 2.6.26.  So I say leave this
> for
> > now, it adds support for users of these devices.
> 
> It's not that big a of a deal and I'm not sure how much of a pain it
> would be to change it, but if the end plan is to have it in the option.c
> driver and it is a one line change we might just want to get it done
> now?

The -stable releases mirror what is in the upstream kernel trees, so I'd
like to keep these the same for now, if at all possible.

I'd also like to have users hardware at least work today, which this
patch does, instead of forcing them to wait 3-4 months for the next
kernel release, for something as simple as adding a device id.

But, if you send me a patch for upstream, that just moves these device
ids over to the option driver, I'll be glad to put it in the next
-stable release as well, which is what I think would be the best overall
option.

thanks,

greg k-h
