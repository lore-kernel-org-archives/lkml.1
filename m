Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYA2Rig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYA2Rig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYA2Ri0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:38:26 -0500
Received: from iabervon.org ([66.92.72.58]:57477 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYA2RiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:38:25 -0500
Date: Tue, 29 Jan 2008 12:38:23 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801291204.44671.gene.heskett@gmail.com>
Message-ID: <alpine.LNX.1.00.0801291220540.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <200801291132.41657.gene.heskett@gmail.com> <18335.22763.625990.528217@alkaid.it.uu.se> <200801291204.44671.gene.heskett@gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Gene Heskett wrote:

> >For starters, enable CONFIG_BLK_DEV_SR.
> 
> That could stand to be moved or renamed, it is well buried in the menu for the 
> REAL scsi stuffs, which I don't have any of.  Enabled & building now.  

The "SCSI support type (disk, tape, CD-ROM)" section of that menu actually 
applies to all ATA-command-set devices that don't use the old IDE code. 
For example, usb-storage uses "SCSI disk" out of that section, and 
I've only seen "Probe all LUNs on each SCSI device" be needed for a 
particular USB card reader with two slots. At this point, most of the 
things in the kernel that refer to SCSI probably should say "storage" (or 
"ATA", really, but that would make the acronyms confusing).

Incidentally, you should be able to save debugging time for problems like 
missing "sr" by building it as a module, which will build really quickly 
and not require a reboot to test.

	-Daniel
*This .sig left intentionally blank*
