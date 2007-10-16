Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbXJPUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbXJPUjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXJPUj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:39:28 -0400
Received: from rtr.ca ([76.10.145.34]:3837 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbXJPUj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:39:27 -0400
Message-ID: <4715217D.2000803@rtr.ca>
Date: Tue, 16 Oct 2007 16:39:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca>	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>	<47150982.6050102@rtr.ca>	<471509FE.7080505@rtr.ca>	<47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
In-Reply-To: <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
>...
> I tried to reproduce this on a Lenovo T61, which does have proper firmware
> support for _OSC, and also has been validated, and the driver which is 
> in 2.6.23-git8 seems to work fine, even across suspend resume.  I suspect
> that your system just doesn't support pcie hotplug properly.

No, the hardware seems to work perfectly.

We just have a software issue.  We *know* it's only software
because rmmod+modprobe fixes things, without any hardware intervention.

I believe the code is leaning too heavily on the BIOS for stuff,
and like lots of other parts of the kernel we'll need an alternate
strategy for when things aren't "perfect".

> You might try getting a BIOS update from Dell.

The machine already has the latest BIOS, thanks.

Cheers
