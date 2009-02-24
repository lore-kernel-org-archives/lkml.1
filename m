Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZBXU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZBXU2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZBXU2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:28:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:11453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbZBXU2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,260,1233561600"; 
   d="scan'208";a="492754992"
Date: Tue, 24 Feb 2009 12:28:08 -0800
From: Matthew Wilcox <willy@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
Message-ID: <20090224202808.GG25248@linux.intel.com>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx> <49A451C3.4000602@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A451C3.4000602@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the review!

On Tue, Feb 24, 2009 at 12:00:03PM -0800, Randy Dunlap wrote:
> Matthew Wilcox wrote:
> > +A Message Signalled Interrupt is a write from the device to a special
> 
> Consistent spelling, please.

Ah yes, I thought I'd fixed that.  I'll follow the PCI spec and use one 'l'.

> > +To support this, the kernel must call each interrupt handler associated
> > +with an interrupt which leads to reduced performance for the system as
> 
>    with an interrupt,

Ack.

> > +Device drivers should normally call this function once per device
> > +during the initialization phase.
> 
> Consistent isation/ization (or ised/ized), please.

The Shorter OED is quite amusing on this point.  It lists 'Initialise' as a
variant, but in the main definition under 'Initialize', the example it
gives of the computer usage uses 'initialise'.  I can only conclude that
a foolish consistency is the hobgoblin of little minds ;-)

> > +4.6 How to tell whether MSI/MSI-X is enabled on a device
> > +
> > +Using lspci -v (as root) will show some devices with "Message Signalled
> 
> Oh gosh, does lspci misspell it?

It used to.  The good news is that recent pciutils now just use MSI
instead of spelling it out.  As a bonus, the capability now fits on one
line.

> > +Interrupts" and others with "MSI-X".  Each of these capabilities have an
> 
>                                          Each ..................... has an

You're correct.

> > +'Enable' flag which will be followed with either "+" (enabled) or "-"
> > +(disabled).


> > +including a full lspci -v so we can add the quirks to the kernel.
> 
>    I would say      "lspci -v" ...

Good idea.

> > +Then, lspci -t gives the list of bridges above a device.  Reading
> 
>          "lspci -t"

Likewise.

> > +It is also worth checking whether the device driver supports MSIs.
> > +
> 
> Unneeded ending blank line (nit).

Heh.  I'll take it out.

May I add your reviewed-by tag?
