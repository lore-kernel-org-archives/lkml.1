Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbXHCPGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbXHCPGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762782AbXHCPGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:06:16 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:38550 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbXHCPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:06:15 -0400
Date: Fri, 3 Aug 2007 16:06:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803150600.GB19968@srcf.ucam.org>
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org> <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 04:43:16PM +0200, Jiri Kosina wrote:

> are you sure about windows suspending the HID devices in runtime? I have 
> never seen LEDs of USB keyboard connected to windows host to go off after 
> some time of not using it.

Ah, sorry - on reading more closely, HID devices will only be 
autosuspended if they're whitelisted.

> We have been playing with runtime autosuspend of HID devices, are 
> currently postponed the full support, as it turns out that many devices 
> don't support this feature properly (probably due to not being tested in 
> Windows).

This doesn't surprise me...
-- 
Matthew Garrett | mjg59@srcf.ucam.org
