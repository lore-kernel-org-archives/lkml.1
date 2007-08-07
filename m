Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbXHGDJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbXHGDJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 23:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXHGDJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 23:09:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:53824 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXHGDI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 23:08:59 -0400
Date: Mon, 6 Aug 2007 20:01:56 -0700
From: Greg KH <gregkh@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Nico Erfurth <masta@perlgolf.de>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH 2.6.22] Adding drivers/usb/misc/iowarrior.c to the
	Makefile
Message-ID: <20070807030156.GB14310@suse.de>
References: <46B23DB0.5010702@perlgolf.de> <20070802212701.GA4326@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802212701.GA4326@uranus.ravnborg.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 11:27:01PM +0200, Sam Ravnborg wrote:
> On Thu, Aug 02, 2007 at 10:25:20PM +0200, Nico Erfurth wrote:
> > This patch adds the new iowarrior module to the Makefile in drivers/usb.
> > Currently the module isn't build unless another driver from usb/misc is
> > selected.
> 
> Can we please just always vist misc like this:
> obj-y := misc/
> 
> Then we do not need to repeat this stuff in both
> drivers/usb/Makefile and drivers/usb/misc/Makefile

For some reason, we didn't do that because people were upset at us going
into these directories when they didn't have any usb misc devices
selected?  Or something like that, I really can't remember anymore.

But if you think it would be best to do that, I'd be glad to make the
change.

thanks,

greg k-h
