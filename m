Return-Path: <linux-kernel-owner+w=401wt.eu-S935421AbXJPS5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935421AbXJPS5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXJPS5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:57:08 -0400
Received: from rtr.ca ([76.10.145.34]:1148 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761150AbXJPS5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:57:07 -0400
Message-ID: <47150982.6050102@rtr.ca>
Date: Tue, 16 Oct 2007 14:57:06 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
In-Reply-To: <20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 16 Oct 2007 14:39:33 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> I also checked my modprobe.d/ options, and I am using pciehp_force=1.
>> Without that flag, none of this ever works.
> 
> OK - I suspected something like this.  Most Dell computers don't support
> ExpressCard hotplug using Native PCIe -- in fact, I've not seen a single
> one, they explicitly disable it because they have not validated it or
> they have and something didn't work right.  I'll take a look at what you've
> got, but be aware that you are forcing pciehp to load and operate on a system
> where they've certainly either not tested it, or tested it and something
> bad happened.

Perhaps.  But this one works perfectly, except for two driver bugs:

1. Driver does not notice already-inserted cards after modprobe.
2. Driver fails to function after suspend/resume until reloaded.

Both of those are fixable in the kernel.

Cheers
