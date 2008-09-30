Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYI3BG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYI3BG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYI3BGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:06:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47862 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYI3BGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:06:17 -0400
Date: Tue, 30 Sep 2008 02:06:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jeffrey W. Baker" <jwbaker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Put unused PCI devices in D3
Message-ID: <20080930010613.GA30375@srcf.ucam.org>
References: <1222719064.19236.129.camel@squeak.gghcwest.com> <20080930000923.GA29775@srcf.ucam.org> <1222736147.21516.12.camel@stinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222736147.21516.12.camel@stinkpad>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 05:55:47PM -0700, Jeffrey W. Baker wrote:

> No, you couldn't, but that isn't really the point.  If I have my laptop
> on a transoceanic flight it may be useful for me to be able to set a
> power policy turning off all the extraneous junk on my machine, because
> I know /a priori/ that no hotplug events will happen.  There's no way
> the kernel could know that, but userspace can tell the kernel to turn
> off an unneeded device.

The majority (though it's not universal) of modern hardware can be put 
into a state where you get most of the power savings of the entire part 
being in D3 but with little functional regression. While I'm not averse 
to adding features that aid the power user who's happy to poke around 
with individual drivers, this shouldn't be at the expense of 
implementing good runtime power management for the more common case.

Not that I'm suggesting you're doing that, I just want to emphasise that 
you're working on a slightly more niche concern :)
-- 
Matthew Garrett | mjg59@srcf.ucam.org
