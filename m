Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYCFSkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYCFSkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYCFSkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:40:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:42473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752388AbYCFSkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:40:01 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX181SFcrqsc1aKGnUlQjyITdFnkkkuV4QCXc6v2FU6
	w44MuyUJznlcsC
Date: Thu, 6 Mar 2008 19:40:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jeff Garzik <jeff@garzik.org>
cc: "Gaston, Jason D" <jason.d.gaston@intel.com>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
In-Reply-To: <47D03272.9080209@garzik.org>
Message-ID: <Pine.LNX.4.64.0803061925190.8669@axis700.grange>
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
 <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange>
 <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange>
 <39B20DF628532344BC7A2692CB6AEE0702679018@orsmsx420.amr.corp.intel.com>
 <47D03272.9080209@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Jeff Garzik wrote:

> Gaston, Jason D wrote:
> > If you disable the IDE Redirection in BIOS on that system, the 0x29b6
> > controller should not appear.  If you are not using this, it would be
> > interesting to see if this effects what you are seeing.
> 
> I think its fair to say that a certain amount of Linux users will inevitably
> have this option enabled in their BIOS.  We should have a plan to deal with
> this sanely...?

Sorry, I am afraid, I caused a bit of confusion here. 0x29b6 I had when 
BIOS configuration was set to "IDE". Then I couldn't use the 0x29b6 at 
all, and therefore couldn't access the external eSATA disk at all. Then I 
switched to AHCI, now all SATA hosts are on PCI ID 0x2922 and 0x29b6 is 
also there as an IDE host unused...

So, now BIOS is set to "AHCI", all SATA hosts - internal and external are 
on PCI ID 0x2922, and external needs a minute to start up, but then it 
works fine.

Thanks
Guennadi
---
Guennadi Liakhovetski
