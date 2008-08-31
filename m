Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYHaR0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYHaR0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYHaRZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:25:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59473 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYHaRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:25:52 -0400
Date: Sun, 31 Aug 2008 18:25:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Message-ID: <20080831172547.GA3077@srcf.ucam.org>
References: <200807241732.23412.trenn@suse.de> <200808291729.53628.trenn@suse.de> <20080830124713.GA5910@srcf.ucam.org> <200808311518.25421.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808311518.25421.trenn@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 03:18:24PM +0200, Thomas Renninger wrote:
> On Saturday 30 August 2008 02:47:13 pm Matthew Garrett wrote:
> > Not really. It provides approximately no complexity for Linux drivers,
> > and makes it easier for vendors to provide Windows support. WMI has not
> > been the hard bit of the drivers I've written. I don't see any reason to
> > ask vendors not to use it,
> Autoloading does not work yet?
> It is working fine with ordinary ACPI devices providing a HID.

That's an implementation detail. We shouldn't be making recommendations 
to vendors based on Linux shortcomings.

> > as long as they're willing to document their 
> > implementation.
> I'll point that out, something like:
> If you really have to use WMI for Windows compatibility reason, make
> sure the important parts (is there already something to mention?
> Against what is the driver loaded -> autoloading?) are documented well.

There's no valid reason to suggest that vendors use an entirely custom 
solution over using WMI. In some ways, reverse engineering is easier - 
we can see all the entry points. But yes, vendors who want to support 
Linux should document their firmware interfaces.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
