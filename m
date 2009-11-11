Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZKKTMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZKKTMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbZKKTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:12:13 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52314 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549AbZKKTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:12:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19v1J+jd6D+ZDIg1YLwzkzD
Date: Wed, 11 Nov 2009 11:12:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20091111191213.GH24837@atomide.com>
References: <20091111193013.9a4bca3e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111193013.9a4bca3e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [091111 00:29]:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-omap.c between commit
> 7cb07f72711d3e10763ca7d7a9fcd7ac788aabf4 ("omap: ehci: Add platform init
> code") from the omap tree and commit
> 9e92239693d7010d2e710a445f46d6a738b09171 ("USB: host: ehci: introduce
> omap ehci-hcd driver") from the usb tree.
> 
> Both commits create this file but I used the omap tree version because
> commit ce491cf85466c3377228c5a852ea627ec5136956 ("omap: headers: Move
> remaining headers from include/mach to include/plat") from the omap tree
> moved one included header file (mach/usb.h -> plat/usb.h).

Oops, sorry. Looks like I accidentally included also drivers/usb/host/ehci-omap.c
as we were testing it in the linux-omap tree.

I'll drop the drivers/usb/host/ehci-omap.c part from my queue, it should get
integrated via Greg's queue. I'll just merge the platform init code.

Regards,

Tony
