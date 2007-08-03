Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbXHCOJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbXHCOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762915AbXHCOJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:09:35 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:53283 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762872AbXHCOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:09:34 -0400
Date: Fri, 3 Aug 2007 15:09:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803140909.GA19245@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org> <200708030701.11404.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708030701.11404.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 07:01:11AM -0700, David Brownell wrote:

> Which is, as I pointed out, the wrong response.  Desktoppy
> people should be making their tools do more intelligent things
> with new USB devices they see ... like updating databases of
> broken devices, and configuring *this* system to know that of
> the devices it regularly deals with, this handful is broken.

Popping up a box saying "Is your device broken?" isn't good UI. 

> > But while this is still a likely probability, the chances are no 
> > distribution is going to ship with CONFIG_USB_SUSPEND enabled.
> 
> So you're saying all the distros want to make PM problems worse?

No. But given a choice between working hardware or marginally better 
runtime PM, they're going to choose working hardware.

> And that with all the other desktoppy stuff they're doing, not one
> of them is willing to help make things better?

This patch is exactly that - a way of getting most of the benefits of 
autosuspend without any real probability of breaking hardware. If you 
mean "Are the distributions willing to pop up dialogs asking users to 
start caring about obscure aspects of the USB spec", then I don't think 
that's actually making things better.

> Pardon me if I want to hear distro vendors agree with you before I
> believe that.

I'm speaking as part of the Ubuntu kernel team, and I've been discussing 
this with Fedora people.

> 
> > Breaking  
> > people's hardware (even if, at a fundamental level, it's the hardware 
> > that's broken) generally irritates users - and I suspect that the users 
> > it'll irritate the most are the ones who won't report it to LKML.
> 
> Having a laptop drain its battery an hour before it needs to is
> also irritating.  (As are the extortionate prices for each model's
> unique batteries, but that's a different issue.)

You commonly run a laptop off battery while having a printer plugged in?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
