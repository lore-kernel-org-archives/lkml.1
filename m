Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbXHCRsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbXHCRsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762760AbXHCRsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:48:41 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:42116 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761227AbXHCRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:48:40 -0400
Date: Fri, 3 Aug 2007 18:48:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803174810.GA23241@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org> <200708031344.03282.oliver@neukum.org> <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org> <20070803174435.GA17053@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803174435.GA17053@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:44:35AM -0700, Greg KH wrote:
> On Fri, Aug 03, 2007 at 01:32:53PM +0100, Matthew Garrett wrote:
> > But while this is still a likely probability, the chances are no 
> > distribution is going to ship with CONFIG_USB_SUSPEND enabled.
> 
> I wouldn't be so sure, I was thinking of doing just that based on an
> internal conversation I had yesterday.

Well, we did - with hindsight it may not have been such a great plan :) 
I believe that Fedora did as well, but have disabled it in an update 
kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
