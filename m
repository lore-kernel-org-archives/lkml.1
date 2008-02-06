Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYBFOLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYBFOLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYBFOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:10:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51988 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbYBFOKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:10:55 -0500
Date: Wed, 6 Feb 2008 14:00:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: ?????? ??????????? <penguinista@mail.net.mk>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
Message-ID: <20080206130004.GC26817@elf.ucw.cz>
References: <200802051840.05237.penguinista@mail.net.mk> <20080205185100.GA4633@kroah.com> <47A8CE10.4010807@intel.com> <200802060105.45363.penguinista@mail.net.mk> <47A8FDDF.6080503@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A8FDDF.6080503@intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 16:22:55, Kok, Auke wrote:
> ?????? ??????????? wrote:
> >>>>> I've patched my kernel with the PCIe ASPM and after setting
> >>>>> echo powersave > /sys/module/pcie_aspm/parameters/policy
> >>>>>
> >>>>> I started to experience random hangs of my laptop.
> >>>>> Hardware info:
> >>>>> Thinkpad x60s 1704-5UG
> >>>> the x60's chipset doesn't support ASPM properly afaik... bad idea.
> >>> Well, the code shouldn't then cause a crash of the machine :)
> >> The user enabled it specifically (where it is disabled by default)
> >>
> >> ASPM has been crashing e1000(e), which is why I've recently merged a patch
> >> to disable L1 ASPM for the onboard 82573 nic on those platforms.
> >>
> >> this new infrastructure should work in the default configuration - enabling
> >> ASPM where this system leaves it disabled is expected to give problems
> >> unless you know what you are doing.
> > 
> > In my defense, the patch documentation didn't say it doesn't work with my 
> > hardware, nor that it hangs the chipset :) and the promised 1.3w surelly 
> > looked nice.
> > 
> > So, are there any benefits of ASPM if I have it in the kernel but it's set to 
> > default? I got the impression that "default" means not much power savings?
> 
> did the Kconfig not come with a big fat (EXPERIMENTAL) ?

(EXPERIMENTAL) is something different from (KNOWN BROKEN).

If we know about broken setups, we should probably be blacklisting
them.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
