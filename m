Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbXHCOIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbXHCOIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761900AbXHCOH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:07:56 -0400
Received: from smtp119.sbc.mail.re3.yahoo.com ([66.196.96.92]:41246 "HELO
	smtp119.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761800AbXHCOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:07:56 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 10:07:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=swbrkeZWpvZsGt7sxWH3fzrBlouo5hy9PbVlkwgFs6h2ljZHOqck2sZKPg2P07q1Df0vHFL0vNdKHZqmv/VZM8PuJhXzYSjPb6/mUt8WxCYZAZhqk3bBS/6q0o6wJ0sgvd5YkG0AneqVj/EwZeifyvieBukkKkEBheEnN6mldls=  ;
X-YMail-OSG: VCtudSgVM1kCrkzMInQW3bCmeDE08zygYzc1hl2onQotMmG0
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
Date: Fri, 3 Aug 2007 07:01:11 -0700
User-Agent: KMail/1.9.6
Cc: Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org>
In-Reply-To: <20070803123253.GA17725@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030701.11404.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 02:26:43PM +0200, Rogan Dawes wrote:
>
> > Which one is more likely to conclude at some point?

Good question ... though "how will it conclude" is also relevant.


> > Compare that to:
> > 
> > "My USB printer broke, guess I'd better report it to LKML".

Which is, as I pointed out, the wrong response.  Desktoppy
people should be making their tools do more intelligent things
with new USB devices they see ... like updating databases of
broken devices, and configuring *this* system to know that of
the devices it regularly deals with, this handful is broken.

Remember, these are the same users who wouldn't know what an
LKML is (do you plug them into the USB port??) if it bit them.


> But while this is still a likely probability, the chances are no 
> distribution is going to ship with CONFIG_USB_SUSPEND enabled.

So you're saying all the distros want to make PM problems worse?

And that with all the other desktoppy stuff they're doing, not one
of them is willing to help make things better?

Pardon me if I want to hear distro vendors agree with you before I
believe that.


> Breaking  
> people's hardware (even if, at a fundamental level, it's the hardware 
> that's broken) generally irritates users - and I suspect that the users 
> it'll irritate the most are the ones who won't report it to LKML.

Having a laptop drain its battery an hour before it needs to is
also irritating.  (As are the extortionate prices for each model's
unique batteries, but that's a different issue.)

