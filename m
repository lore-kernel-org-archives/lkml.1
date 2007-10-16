Return-Path: <linux-kernel-owner+w=401wt.eu-S966724AbXJPWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966724AbXJPWUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966642AbXJPWTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:19:05 -0400
Received: from rtr.ca ([76.10.145.34]:4782 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966426AbXJPWTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:19:02 -0400
Message-ID: <471538D4.1020001@rtr.ca>
Date: Tue, 16 Oct 2007 18:19:00 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix PCIe hotplug for Dell notebook ExpressCard slots
References: <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <20071016220354.GA22828@kroah.com>
In-Reply-To: <20071016220354.GA22828@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Oct 16, 2007 at 05:57:03PM -0400, Mark Lord wrote:
>> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
>> in conjunction with modparam of pciehp_force=1.
>>
>> The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
>> which lack ACPI BIOS support for PCIe hotplug:
> 
> Wait, Dell explicitly says that pci hotplug of express cards is not
> supported and is broken on these laptops.  This is because the version
> of Windows they support on these machines also does not support
> hotplugging these devices.
> 
> The current code works just fine on hardware that actually supports this
> kind of functionality, as per the proper specs and requirements for this
> feature.
> 
> So why try to go through these gyrations for hardware that is explicitly
> broken?

Because it is NOT broken.  It works perfectly.

There's just a couple of issues in the existing *working* Linux driver
that need fixing, that's all.

Cheers
