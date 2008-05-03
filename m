Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYECS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYECS6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYECS6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:58:03 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:51314 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYECS6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:58:00 -0400
Date: Sat, 3 May 2008 14:57:58 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: James Smart <James.Smart@Emulex.Com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [2.6.25] lpfc driver problem
In-Reply-To: <481B33C9.5070500@emulex.com>
Message-ID: <alpine.DEB.1.10.0805031452020.2330@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net> <20080501211659.8a2e0686.akpm@linux-foundation.org> <alpine.DEB.1.10.0805020714500.21142@mtl.rackplans.net> <481B33C9.5070500@emulex.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, James Smart wrote:
> Gerhard Mack wrote:
> > 
> > > On Tue, 29 Apr 2008 16:28:03 -0400 (EDT) Gerhard Mack
> > > <gmack@innerfire.net> wrote:
> > > 
> > > > hello
> > > > 
> > > > I'm getting the following error when trying to load the lpfc driver.
> > > > This is a new install so I have no idea if this is a regression or not.
> > > > 
> > > > dmesg output:
> > > > Emulex LightPulse Fibre Channel SCSI driver 8.2.5
> > > > Copyright(c) 2004-2008 Emulex.  All rights reserved.
> > > > scsi2 :  on PCI bus 02 device 50 irq 24
> > > > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg
> > > > x400000, FW Data: A8 x0 AC x0
> > > > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg
> > > > x400000, FW Data: A8 x0 AC x0
> > > > 
> > > > Card is:
> > > > 02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host
> > > > Adapter (rev 02)
> > > > 02:0a.0 0c04: 10df:f800 (rev 02)
> > > (Cc's added)
> 
> The error indicates that the adapter did not respond to a basic port reset,
> which we do before we try to bring up it's messaging interface, etc.
> This likely means it failed POST or some other hardware error. The LED's on
> the backpanel would have indicated the condition. The LP8000 is a pretty old
> board and was EOL'd years ago, so it doesn't surprise me that something like
> this could pop up.
> 

Not shocking.... my customers tend to spend more in my wages than they 
would have saved on hardware buying things from the junk pile.  This was 
actually the 4th non working card from said computer junk store.

> > 
> > I am no longer able to debug this.  My client took the card back and traded
> > it for a Qlogic.
> 
> As much as any vendor hates to see a customer switch :( I understand
> expediency...

If it makes you feel better I have a Qlogic that causes the machine to 
reset during the bios init.

> 
> As an fyi - to help the debug, whether it be Emulex or Qlogic, or someone
> else,
> I recommend that you cat the various /sys/class/scsi_host/hostX/* and
> /sys/class/fc_host/hostX/* attributes (where hostX corresponds to the scsi?
> bus\
> number assigned to the adapter).  Assuming the adapter attaches enough for
> these
> things to exist, it will give us a lot more information about the adapter for
> debug.

I don't think it attached long enough for that to happen.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
