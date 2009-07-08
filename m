Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZGHWbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZGHWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZGHWbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:37 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:53575 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbZGHWbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:36 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Wed, 8 Jul 2009 17:31:29 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907081658260.22105-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907081658260.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081731.33106.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed July 8 2009, Alan Stern wrote:
> On Wed, 8 Jul 2009, Michael S. Zick wrote:
> 
> > > Like I've been telling you all along, the hardware isn't working.  
> > >
> > 
> > That sounds very fragile.
> 
> I'm not sure how to interpret that sentence.  If you mean that your
> system's hardware design isn't good, I agree.  If you mean that the
> kernel shouldn't produce a lot of output when faced with broken
> hardware, that's not so clear.  What else should it do (bearing in mind
> that the kernel can't tell the hardware is broken)?
> 

It is unlikely that VIA Tech. will recall the CX700 chipset.

So being able to take a device off-line (like the driver claims it is doing)
and *leave* it off-line - until told to "try again" - that would be an
improvement.

The current process of filling up the /var/log directory until the machine
chokes is a rather fragile sort of response to a hot-plugged device, good or bad.

> > > I suspect it's worse than a simple interrupt-routing mistake.
> > > 
> > 
> > I would not object to your removing that one mistake - that is one less
> > to contend with.
> 
> I didn't say there was an interrupt-routing mistake; I said it was 
> _worse_ than an interrupt-routing mistake.
> 

Never claimed you did - the driver made that claim.
But still, it would be nice to get rid of the interrupt-routing mistake.

I suppose waiting for the OLPC project to find and fix the problem is 
a viable alternative also.
You will not be the first to give up on this C7-M/CX700 combination. ;)

> > > > > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > > > > see what's sitting in the usb/uhci/* files in debugfs.
> > > > > > 
> > > > 
> > 
> > Fours up-time - nothing written to dmesg since boot -
> > Just the usual hard-lockup.
> > 
> > Also - something in the combined fix/diagnostic patch
> > disable any sensing of external usb events.
> > So I couldn't very well poke devices at it.  ;)
> 
> You should take out those BUG statements.  If they ever trigger, they 
> will certainly lock up your system.
>

Although I would expect that they not do so silently.

I take them out and just in time before starting the next 
round of testing.

Mike 
> Alan Stern
> 
> 
> 


