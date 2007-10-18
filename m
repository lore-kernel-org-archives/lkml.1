Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXJRCZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXJRCZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXJRCZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:25:33 -0400
Received: from rtr.ca ([76.10.145.34]:4903 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbXJRCZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:25:33 -0400
Message-ID: <4716C418.6090708@rtr.ca>
Date: Wed, 17 Oct 2007 22:25:28 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 2/4] Fix PCIe hotplug for non-ACPI ExpressCard
 slots (version 2)
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca>	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>	<47150982.6050102@rtr.ca>	<471509FE.7080505@rtr.ca>	<47151191.40406@rtr.ca>	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>	<4715217D.2000803@rtr.ca>	<20071016214143.GC21815@kroah.com>	<471533AF.60100@rtr.ca>	<47156B14.2080608@rtr.ca>	<47156B40.4060006@rtr.ca>	<47156B62.3070807@rtr.ca> <20071017165416.3099059b.kristen.c.accardi@intel.com>
In-Reply-To: <20071017165416.3099059b.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 16 Oct 2007 21:54:42 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Fix pciehp_probe() to deal with pre-inserted ExpressCard cards,
>> but only when pciehp_force==1.  Otherwise behaviour is unmodified.
> 
> I think it would be ok to try allowing the slot to be enabled when not
> using pciehp_force mode.  We can wrap it later if it proves to break 
> things, however, see my comment below:


Could you test that on ACPI-supported hardware and report back, please.

...
> Here it seems like what you want to do just go ahead and try to call
> pciehp_enable_slot always, but check the return value.  If an adapter is
> not present, it will return -ENODEV, and then you can check to see if
> you have the ability to power off the slot, and try to power it off.

Okay, will do.

> Please fix CodingStyle issues too.

????

