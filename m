Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbXHCPEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbXHCPEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXHCPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:04:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762029AbXHCPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:04:32 -0400
Date: Fri, 3 Aug 2007 10:53:21 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803145321.GB17138@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Kosina <jikos@jikos.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
	Greg KH <gregkh@suse.de>, Rogan Dawes <lists@dawes.za.net>,
	Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
	David Brownell <david-b@pacbell.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb-devel@lists.sourceforge.net
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org> <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 04:43:16PM +0200, Jiri Kosina wrote:
 > On Fri, 3 Aug 2007, Matthew Garrett wrote:
 > 
 > > Windows will autosuspend hubs, bluetooth devices, HID devices
 > 
 > Hi Matthew,
 > 
 > are you sure about windows suspending the HID devices in runtime? I have 
 > never seen LEDs of USB keyboard connected to windows host to go off after 
 > some time of not using it.

Not so sure about keyboards, but I've seen the LEDs on USB mice dim or go off
after a few seconds of inactivity under Windows, but under Linux they stay on.

 > We have been playing with runtime autosuspend of HID devices, are 
 > currently postponed the full support, as it turns out that many devices 
 > don't support this feature properly (probably due to not being tested in 
 > Windows).

Interesting.  Which devices did you notice failing?
Was it a case that they would sleep and not come back out of that state?

	Dave

-- 
http://www.codemonkey.org.uk
