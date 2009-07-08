Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbZGHUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbZGHUWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZGHUW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:22:29 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:39661 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZGHUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:22:28 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Wed, 8 Jul 2009 15:22:19 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907081555310.22105-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907081555310.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081522.22026.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed July 8 2009, Alan Stern wrote:
> On Wed, 8 Jul 2009, Michael S. Zick wrote:
> 
> > But, then again, we might just get lucky:
> > ehci_hcd 0000:00:10.4: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
> > usb 1-5: khubd timed out on ep0in len=18/64
> 
> Like I've been telling you all along, the hardware isn't working.  
>

That sounds very fragile.

> I suspect it's worse than a simple interrupt-routing mistake.
> 

I would not object to your removing that one mistake - that is one less
to contend with.

> > > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > > see what's sitting in the usb/uhci/* files in debugfs.
> > > > 
> > 

Fours up-time - nothing written to dmesg since boot -
Just the usual hard-lockup.

Also - something in the combined fix/diagnostic patch
disable any sensing of external usb events.
So I couldn't very well poke devices at it.  ;)

> > Anything in particular to look for/at?
> 
> Just post the contents of those files.
> 

Will capture that information during this afternoon's testing.

Mike
> Alan Stern
> 
> 
> 


