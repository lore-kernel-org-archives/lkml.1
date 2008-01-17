Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYAQU5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYAQU5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYAQU44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:56:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:50092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbYAQU4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:56:55 -0500
Date: Thu, 17 Jan 2008 10:04:53 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Message-ID: <20080117180453.GA7780@suse.de>
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de> <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local> <20080111210234.GA3070@suse.de> <3415E2A2AB26944B9159CDB22001004D022577B3@nestea.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D022577B3@nestea.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:21:32AM -0800, Kevin Lloyd wrote:
> > Hm, no, the intrusion into the driver is just too much this late in
> the
> > release cycle to allow this.
> >
> > Now I will be glad to only add the new device ids for the devices that
> > do not rely on the new changes right now, but that's it.
> >
> > So, right now I have a separate patch split out of your original one
> > that is below.  Should I modify it and not include some of these
> device
> > ids right now?  You mention 0023, is that the only one I should remove
> > from this patch?
> 
> Correct, the 0x0023 is the only newly added device that requires the new
> features.

Does that mean things will not work for this device if it is added to
the device table, without the code updates?

And is this device even public yet?

> When do you expect the other changes will be propagated to the kernel?
> Would it be in a 2.6.24.x point release or will they have to wait until
> 2.6.25?

They will have to wait until 2.6.25, they are too big to go into 2.6.24
(we are in severe bug-fix mode only right now for .24).

thanks,

greg k-h
