Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXCOTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXCOTGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXCOTGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:06:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXCOTGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:06:50 -0400
Date: Thu, 15 Mar 2007 11:06:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PCI probing failure in 2.6.21-rc3
Message-Id: <20070315110647.710bff5f.akpm@linux-foundation.org>
In-Reply-To: <38b2ab8a0703140147s24bfc656o1bbff4abc405d61d@mail.gmail.com>
References: <38b2ab8a0703140147s24bfc656o1bbff4abc405d61d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 09:47:42 +0100 "Francis Moreau" <francis.moro@gmail.com> wrote:
> I already posted this issue but it was on a 2.6.19.7 kernel
> (2.6.19-1.2911.6.5.fc6 to be accurate). So it doesn't seem to be a
> regression.
> 
> During boot the console shows up this:
> 
> [...]
> PCI: Probing PCI hardware (bus 00)
> PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> PCI quirk: region 1180-11bf claimed by ICH6 GPIO
> 0000:00:1f.2: trying to change BAR0 from 0000 to 01F0
> 0000:00:1f.2: trying to change BAR1 from 0000 to 03F4
> 0000:00:1f.2: trying to change BAR2 from 0000 to 0170
> 0000:00:1f.2: trying to change BAR3 from 0000 to 0374
> Boot video device is 0000:01:00.0
> PCI: Transparent bridge - 0000:00:1e.0
> PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07)
> (try 'pci=assign-busses')
> Please report the result to linux-kernel to fix this permanently
> [...]
> 
> I haven't time to test 'pci=assign-busses' option, I'll do it later,
> but I wanted to report this ASAP.

Greg, could we please either 

a) start doing something about these reports or
b) publish sufficient info to permit others to do something about these
   reports or 
c) remove the printk?

Thanks.
