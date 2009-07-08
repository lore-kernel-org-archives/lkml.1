Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZGHVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZGHVC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZGHVCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:02:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45181 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511AbZGHVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:02:50 -0400
Date: Wed, 8 Jul 2009 17:02:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907081522.22026.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907081658260.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Michael S. Zick wrote:

> > Like I've been telling you all along, the hardware isn't working.  
> >
> 
> That sounds very fragile.

I'm not sure how to interpret that sentence.  If you mean that your
system's hardware design isn't good, I agree.  If you mean that the
kernel shouldn't produce a lot of output when faced with broken
hardware, that's not so clear.  What else should it do (bearing in mind
that the kernel can't tell the hardware is broken)?

> > I suspect it's worse than a simple interrupt-routing mistake.
> > 
> 
> I would not object to your removing that one mistake - that is one less
> to contend with.

I didn't say there was an interrupt-routing mistake; I said it was 
_worse_ than an interrupt-routing mistake.

> > > > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > > > see what's sitting in the usb/uhci/* files in debugfs.
> > > > > 
> > > 
> 
> Fours up-time - nothing written to dmesg since boot -
> Just the usual hard-lockup.
> 
> Also - something in the combined fix/diagnostic patch
> disable any sensing of external usb events.
> So I couldn't very well poke devices at it.  ;)

You should take out those BUG statements.  If they ever trigger, they 
will certainly lock up your system.

Alan Stern

