Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYBFR10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYBFR10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYBFR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:27:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYBFR1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:27:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
Date: Wed, 6 Feb 2008 18:25:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       ?????? ??????????? <penguinista@mail.net.mk>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
References: <200802051840.05237.penguinista@mail.net.mk> <47A8FDDF.6080503@intel.com> <20080206130004.GC26817@elf.ucw.cz>
In-Reply-To: <20080206130004.GC26817@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061825.21692.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of February 2008, Pavel Machek wrote:
> On Tue 2008-02-05 16:22:55, Kok, Auke wrote:
> > ?????? ??????????? wrote:
> > >>>>> I've patched my kernel with the PCIe ASPM and after setting
> > >>>>> echo powersave > /sys/module/pcie_aspm/parameters/policy
> > >>>>>
> > >>>>> I started to experience random hangs of my laptop.
> > >>>>> Hardware info:
> > >>>>> Thinkpad x60s 1704-5UG
> > >>>> the x60's chipset doesn't support ASPM properly afaik... bad idea.
> > >>> Well, the code shouldn't then cause a crash of the machine :)
> > >> The user enabled it specifically (where it is disabled by default)
> > >>
> > >> ASPM has been crashing e1000(e), which is why I've recently merged a patch
> > >> to disable L1 ASPM for the onboard 82573 nic on those platforms.
> > >>
> > >> this new infrastructure should work in the default configuration - enabling
> > >> ASPM where this system leaves it disabled is expected to give problems
> > >> unless you know what you are doing.
> > > 
> > > In my defense, the patch documentation didn't say it doesn't work with my 
> > > hardware, nor that it hangs the chipset :) and the promised 1.3w surelly 
> > > looked nice.
> > > 
> > > So, are there any benefits of ASPM if I have it in the kernel but it's set to 
> > > default? I got the impression that "default" means not much power savings?
> > 
> > did the Kconfig not come with a big fat (EXPERIMENTAL) ?
> 
> (EXPERIMENTAL) is something different from (KNOWN BROKEN).
> 
> If we know about broken setups, we should probably be blacklisting
> them.

Well, the ASPM thing seems to break every single setup I've tested.  So,
perhaps we should whitelist the working ones?

Rafael
