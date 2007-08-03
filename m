Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbXHCPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbXHCPLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762565AbXHCPLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:11:00 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:36068 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762417AbXHCPK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:10:59 -0400
Date: Fri, 3 Aug 2007 16:10:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803151037.GD19968@srcf.ucam.org>
References: <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.44L0.0708031038170.2597-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708031038170.2597-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:41:13AM -0400, Alan Stern wrote:
> On Fri, 3 Aug 2007, Matthew Garrett wrote:
> > I'm not so 
> > enthusiastic about the "Increase the timeout case" - it doesn't avoid 
> > any races, just makes them less likely. USB is likely to get loaded in 
> > the initramfs, but we may not have a full set of udev rules until the 
> > root fs is up and that can take an effectively arbitrarily large amount 
> > of time.
> 
> If it takes longer than 15 minutes, something is wrong.  At that point 
> the user will have worse things to worry about than whether some USB 
> devices got suspended.

Imagine cases where / is fscked from initramfs?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
