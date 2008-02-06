Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbYBFAF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbYBFAF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbYBFAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:05:51 -0500
Received: from mail.contimak.com ([217.16.69.3]:46017 "EHLO on.net.mk"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758254AbYBFAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:05:50 -0500
From: =?utf-8?b?0JTQsNC80ZjQsNC9INCT0LXQvtGA0LPQuNC10LLRgdC60Lg=?= 
	<penguinista@mail.net.mk>
Organization: =?utf-8?b?0KHQu9C+0LHQvtC00LXQvSDRgdC+0YTRgtCy0LXRgA==?=
 =?utf-8?b?INCc0LDQutC10LTQvtC90LjRmNCw?=
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
Date: Wed, 6 Feb 2008 01:05:44 +0100
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
References: <200802051840.05237.penguinista@mail.net.mk> <20080205185100.GA4633@kroah.com> <47A8CE10.4010807@intel.com>
In-Reply-To: <47A8CE10.4010807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060105.45363.penguinista@mail.net.mk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> I've patched my kernel with the PCIe ASPM and after setting
> >>> echo powersave > /sys/module/pcie_aspm/parameters/policy
> >>>
> >>> I started to experience random hangs of my laptop.
> >>> Hardware info:
> >>> Thinkpad x60s 1704-5UG
> >>
> >> the x60's chipset doesn't support ASPM properly afaik... bad idea.
> >
> > Well, the code shouldn't then cause a crash of the machine :)
>
> The user enabled it specifically (where it is disabled by default)
>
> ASPM has been crashing e1000(e), which is why I've recently merged a patch
> to disable L1 ASPM for the onboard 82573 nic on those platforms.
>
> this new infrastructure should work in the default configuration - enabling
> ASPM where this system leaves it disabled is expected to give problems
> unless you know what you are doing.

In my defense, the patch documentation didn't say it doesn't work with my 
hardware, nor that it hangs the chipset :) and the promised 1.3w surelly 
looked nice.

So, are there any benefits of ASPM if I have it in the kernel but it's set to 
default? I got the impression that "default" means not much power savings?


-- 
Damjan Georgievski
Free Software Macedonia
