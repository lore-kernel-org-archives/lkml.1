Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbXHCTaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbXHCTaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbXHCT34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:29:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbXHCT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:29:55 -0400
Message-ID: <46B38211.4030004@redhat.com>
Date: Fri, 03 Aug 2007 15:29:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Greg KH <gregkh@suse.de>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
 device classes
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org> <200708031344.03282.oliver@neukum.org> <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org> <20070803174435.GA17053@suse.de> <20070803174810.GA23241@srcf.ucam.org>
In-Reply-To: <20070803174810.GA23241@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2007 01:48 PM, Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 10:44:35AM -0700, Greg KH wrote:
>> On Fri, Aug 03, 2007 at 01:32:53PM +0100, Matthew Garrett wrote:
>>> But while this is still a likely probability, the chances are no 
>>> distribution is going to ship with CONFIG_USB_SUSPEND enabled.
>> I wouldn't be so sure, I was thinking of doing just that based on an
>> internal conversation I had yesterday.
> 
> Well, we did - with hindsight it may not have been such a great plan :) 
> I believe that Fedora did as well, but have disabled it in an update 
> kernel.

Yeah, autosuspend broke too many devices. Way too many.

