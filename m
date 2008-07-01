Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYGASpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYGASpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbYGASnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:53 -0400
Received: from lucidpixels.com ([75.144.35.66]:49980 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927AbYGASnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:51 -0400
Date: Tue, 1 Jul 2008 14:43:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: crmotherboard@mailbox.cps.intel.com, Jesse Barnes <jesse.barnes@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: Intel DG965WH / Case 745-44-22 (slow bios/upgrade) [UPDATE] /
 Intel, status of HECI support patch for the kernel?
In-Reply-To: <alpine.DEB.1.10.0806300958070.13171@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807011442500.18141@p34.internal.lan>
References: <alpine.DEB.1.10.0806300958070.13171@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jun 2008, Justin Piszcz wrote:

> Hello,
>
> I have two revisions of the 965WH motherboard, one that supports dual-core 
> only and another quad-core.
>
> I have an E6300 in the old one and a Q6600 in the new one with 4GiB and 8GiB 
> of RAM respectively.
>
> I would like to report a success and also a bug with BIOS 1738.
>
> The success is this case can be resolved, the Linux/memory/mapping is correct 
> now and I no longer have to use mem="8832M" in my LILO configuration to avoid 
> the bios setting memory that is not cachable.
>
> However, on my new revision 965WH (I did not check with my old motherboard), 
> that supports the quad-core CPU, I went into the BIOS and went to the [Hard 
> Disks] option and when I selected it, the part of the screen that should 
> update showing me the hard disks in the system was blank, I could not escape 
> out of the bios or go to another menu, I had to reboot to get back into the 
> bios.  This is not normal behavior, can someone at Intel attach 1-6 (I use 6) 
> WD Veliciraptor 300GiB drives to this motherboard to replicate the problem if
> it is not obvious in the code/bios how to fix it?  I cannot view the hard 
> disks in that menu, I believe its the 2nd or 3rd menu over when you initially 
> enter the BIOS.  I do not recall if this problem existed prior to 1738.
>
> Also, people have e-mailed me in relation to my posts and I am curious as 
> well
> to follow up, when will the HECI/fan/voltage sensor support (that is a 
> project
> at Intel) be merged into the kernel tree so that lm sensors will eventually 
> be
> able to read these values?
>
> This is from 2007:
> http://softwareblogs.intel.com/2007/04/13/intel-me-interface-heci-now-available/
>
> Their updated project page:
> http://www.openamt.org/
>
> Justin.
>

The issue regarding accessing the hard drive menu was fixed by simpling 
power cycling/rebooting the host.

All issues are now resolved (regarding the slow speed/memory/etc)..

Only other question left is the HECI support in the kernel.

Justin.
