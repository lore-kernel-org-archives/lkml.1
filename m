Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402Ab0AEJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0AEJwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563Ab0AEJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:52:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:48384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab0AEJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:52:14 -0500
Date: Tue, 5 Jan 2010 10:52:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
In-Reply-To: <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LNX.2.00.1001051048150.2277@pobox.suse.cz>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>    <20091216103423.GE1377@ucw.cz>    <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz> <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Rick L. Vinyard, Jr. wrote:

> >> > This patch is against the torvalds/linux-2.6.git tree.
> >>
> >> Should this use auxdisplay framework and be located there?
> >
> > Well, the device is still primarily HID device in its nature, so either
> > keeping the whole driver in drivers/hid, or separating it into two
> > drivers, one for the HID part and second for the framebuffer part should
> > be acceptable.
> 
> The framebuffer part uses the same interrupt endpoint for both HID and
> display. IIRC there were issues with two drivers using the same interrupt
> endpoint.

I have no objection to keeping this as a single driver in drivers/hid, 
provided that the framebuffer part gets reviewed by someone more familiar 
with the framebuffer code than I am.

> > I will proceed with reviewing the driver soon, sorry for slightly higher
> > latencies these days.
> 
> No problem... as you can see my latency responding is rather high.

Also please see the other thread about the build failures I am getting 
with this drivers (and it's not fixed solely by making the driver 
dependent on FB_DEFERRED_IO (namely it doesn't like to be built in as 
module, because of the symbol name clashes with hid-lg).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
