Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbYA2SAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbYA2SAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYA2SAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:00:08 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:41485 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYA2SAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:00:06 -0500
Date: Tue, 29 Jan 2008 12:59:54 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <alpine.LNX.1.00.0801291220540.13593@iabervon.org>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801291259.54262.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801291204.44671.gene.heskett@gmail.com>
 <alpine.LNX.1.00.0801291220540.13593@iabervon.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Daniel Barkalow wrote:
>On Tue, 29 Jan 2008, Gene Heskett wrote:
>> >For starters, enable CONFIG_BLK_DEV_SR.
>>
>> That could stand to be moved or renamed, it is well buried in the menu for
>> the REAL scsi stuffs, which I don't have any of.  Enabled & building now.
>
>The "SCSI support type (disk, tape, CD-ROM)" section of that menu actually
>applies to all ATA-command-set devices that don't use the old IDE code.
>For example, usb-storage uses "SCSI disk" out of that section, and
>I've only seen "Probe all LUNs on each SCSI device" be needed for a
>particular USB card reader with two slots. At this point, most of the
>things in the kernel that refer to SCSI probably should say "storage" (or
>"ATA", really, but that would make the acronyms confusing).
>
>Incidentally, you should be able to save debugging time for problems like
>missing "sr" by building it as a module, which will build really quickly
>and not require a reboot to test.
>
>	-Daniel
>*This .sig left intentionally blank*

I did, Daniel, but while that has worked, its not been 100% foolproof in the 
past, so I just waste the 9 minutes building a new kernel as cheap insurance.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Mal: "If it's Alliance trouble you got, you might want to consider another
ship. Some onboard here fought for the Independents."
				--Episode #8, "Out of Gas"
