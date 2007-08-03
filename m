Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbXHCL3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbXHCL3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbXHCL3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:29:36 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:36113 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759863AbXHCL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:29:36 -0400
Date: Fri, 3 Aug 2007 12:28:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Message-ID: <20070803112824.GA16802@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708022301.08719.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 11:01:08PM -0700, David Brownell wrote:

> Seems to me it ought to be practical to organize a database that can
> be consulted by an outcall from udev, disabling autosuspend on devices
> which are known to be broken.  The "modules.usbmap" syntax is an obvious
> place to start (painful though it is), and I'm sure there are folk who
> would prefer web-accessible/updatable databases.

It's certainly possible to do that, but it's also possible to have a 
userspace solution that whitelists devices. The question is whether the 
default kernel behaviour should be "Save power, but potentially break 
some of my devices" or "Don't break my devices, but use some more 
powre".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
