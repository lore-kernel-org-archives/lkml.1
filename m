Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXCOJYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXCOJYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXCOJYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:24:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:48945 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXCOJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=lbtcVAbwkPMoWQzq6CoeoP3EaHaHPwA6wtAAS7AdB0SSp+mw7kI3IHJfVwZPbB1ORe9vpOdWvngPTLGlN3/JYxyWBm0uQH9vtEC6/3KZM6UWo/uZSdj4CfwyL1UcRRhA7DDvDXylwhtuwfq72PBCcR9uQ8HbrVcfenXS0Xe3xDg=
Date: Thu, 15 Mar 2007 09:22:41 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: ipw2200: can't load firmware (was Re: 2.6.21-rc3-mm1)
Message-ID: <20070315092241.GA16781@slug>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <20070309114043.GE12727@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309114043.GE12727@slug>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 11:40:43AM +0000, Frederik Deweerdt wrote:
> On Wed, Mar 07, 2007 at 08:18:39PM -0800, Andrew Morton wrote:
> > - The wireless changes in here need a lot of testers, please.  It is major
> >   rework.
> [...]
> >   I was able to get ipw2200 working after some fumbling,
> Any details on the symptoms? I'm unable to boot rc3-mm2, and it hangs
> right after printing the ipw2200 driver message. I'll investigate that
> this week-end.
Sorry for the delay, I could give it a try today. It appears
that it doesn't hang, it just spends a lot of time in
ipw_init:pci_register_driver, due to a firmware loading failure

[   12.296637] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
[   12.322581] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kdmprq
[   12.348822] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   12.366936] PCI: Found IRQ 10 for device 0000:03:03.0
[   12.376280] PCI: Sharing IRQ 10 with 0000:00:1d.1
[   12.385729] PCI: Sharing IRQ 10 with 0000:00:1e.3
[   12.395134] PCI: Sharing IRQ 10 with 0000:00:1f.2
[   12.404385] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[   72.391870] ipw2200: ipw2200-bss.fw request_firmware failed: Reason -2
[   72.400563] ipw2200: Unable to load firmware: -2
[   72.408956] ipw2200: failed to register network device
[   72.417178] ipw2200: probe of 0000:03:03.0 failed with error -5

(Booted with acpi=off due to some framebuffer problems mangling the
console output, but the problem persists even without that kernel
parameter)

Regards,
Frederik
