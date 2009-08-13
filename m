Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZHMVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZHMVmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZHMVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:42:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51407 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbZHMVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:42:20 -0400
Date: Thu, 13 Aug 2009 22:42:19 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC] usb: Add support for runtime power management
	of the hcd
Message-ID: <20090813214219.GB14532@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl> <200908131416.42189.oliver@neukum.org> <20090813123034.GA25770@srcf.ucam.org> <200908131626.33891.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131626.33891.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:26:33PM +0200, Oliver Neukum wrote:
> Am Donnerstag, 13. August 2009 14:30:34 schrieb Matthew Garrett:
> > > Your earlier failures don't look promising regarding BIOSes.
> > > What do you have in mind?
> >
> > They range from pragmatic to ugly. We could blacklist all Dells, though
> > I'm trying to find out if there's a BIOS date that guarantees the system
> > is fixed. Alternatively, it's a single-line bug in the DSDT - we could
> > implement some kind of fixup in the ACPI parsing code. I find the latter
> > interesting but possibly too hideous to live :)
> 
> Is there any indication only those BIOSes are affected?

Based on what I've looked at, other BIOSes either indicate that they 
don't support this or should work properly. Real life may disagree.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
