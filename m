Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXHBM4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXHBM4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbXHBMzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:55:52 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:36384 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXHBMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:55:52 -0400
Date: Thu, 2 Aug 2007 13:55:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Message-ID: <20070802125541.GC30304@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de> <1186048701.18821.459.camel@queen.suse.de> <20070802120221.5474e732@the-village.bc.nu> <20070802111327.GA29002@srcf.ucam.org> <1186055100.18821.494.camel@queen.suse.de> <20070802115631.GA29735@srcf.ucam.org> <1186058539.18821.523.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186058539.18821.523.camel@queen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:42:19PM +0200, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 12:56 +0100, Matthew Garrett wrote:
> > The policy has been to attempt to be bug-compatible with Windows 
> > whenever possible for some time now.
> *whenever possible*

But there's no evidence whatsoever that this is something we can't 
handle...

> > No, that's not the only reason for notifications. Alteration in hardware 
> > state may also force a recalculation of trip point (adding a battery to 
> > a bay rather than a DVD drive may require the platform to be kept at a 
> > lower temperature)
> "I've seen no evidence that this happens...", but I see the point.

It's explicitly mentioned as one of the use cases for trip point 
alteration in the spec.

> > Surely people want this functionality so that they can raise trip 
> > points?
> For Adrian it would be enough to be able to lower them.

Which suggests that we're probably doing something wrong at some more 
fundamental level...

> Also being able to define a passive trip point (even if not provided by
> BIOS) could help a lot machines.

I agree that being able to lower trip points is unlikely to result in 
hardware damage, but still think that it's likely to be papering over 
genuine bugs that we could fix properly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
