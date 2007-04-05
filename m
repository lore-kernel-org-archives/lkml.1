Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXDEOfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXDEOfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXDEOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:35:08 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37755 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXDEOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:35:06 -0400
Date: Thu, 05 Apr 2007 08:34:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IRQ splitting
In-reply-to: <fa.21iotKLTgoLpkKhrbSxrjy5v7hM@ifi.uio.no>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <46150913.4000406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.21iotKLTgoLpkKhrbSxrjy5v7hM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hello list,
> 
> 
> 
> let's take the following /proc/interrupts dump (CPU2,CPU3 trimmed)...
> 
>            CPU0       CPU1
>   0:   37041766   37038991  IO-APIC-edge  timer
>   1:         10          2  IO-APIC-edge  i8042
>   8:          0          0  IO-APIC-edge  rtc
>   9:          0          0  IO-APIC-level  acpi
>  12:        114          0  IO-APIC-edge  i8042
>  14:      25219    5800049  IO-APIC-edge  ide0
> 201:     260381     238454  IO-APIC-level  aacraid
> 209:          0          0  IO-APIC-level  ohci_hcd:usb1
> 217:          0          0  IO-APIC-level  ehci_hcd:usb2
> 225:   57531742          0  IO-APIC-level  eth0,radeon@pci:0000:03:00.0
> 233:         26          0  IO-APIC-level  eth1
> NMI:       1661       1397
> LOC:  147579966  147579949
> ERR:          0
> MIS:          0
> 
> My question is whether it is possible that eth0's interrupts go to CPU0
> and radeon's to CPU1, and if so, how I would enable that. Alternatively,
> is it possible to just move eth0 or radeon to a different interrupt?

Generally (at least in APIC mode) the IRQ assignments are based on 
hard-wired interrupt lines on the board. In this case, the slots that 
the Radeon and eth0 card are in likely share a physical interrupt line 
and there is no way to separate them in software. You can try moving the 
  card(s) to different slots..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

