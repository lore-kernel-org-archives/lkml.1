Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXHCUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXHCUTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXHCUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:19:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXHCUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:19:27 -0400
Date: Fri, 3 Aug 2007 16:12:39 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803201239.GB20376@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
	linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org> <200708031344.03282.oliver@neukum.org> <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org> <20070803174435.GA17053@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803174435.GA17053@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:44:35AM -0700, Greg KH wrote:
 > On Fri, Aug 03, 2007 at 01:32:53PM +0100, Matthew Garrett wrote:
 > > On Fri, Aug 03, 2007 at 02:26:43PM +0200, Rogan Dawes wrote:
 > > 
 > > > Compare that to:
 > > > 
 > > > "My USB printer broke, guess I'd better report it to LKML".
 > > 
 > > But while this is still a likely probability, the chances are no 
 > > distribution is going to ship with CONFIG_USB_SUSPEND enabled.
 > 
 > I wouldn't be so sure, I was thinking of doing just that based on an
 > internal conversation I had yesterday.
 > 
 > Let's see what breaks and what happens :)

here's a head start for you.

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243038
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246713
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243953
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242359

That's just the ones that were handy..

	Dave

-- 
http://www.codemonkey.org.uk
