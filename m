Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYDKGG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYDKGG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYDKGGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:06:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:62290 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYDKGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CIrox5juC+SWPciFs6fbIQa3N5K4nvPhDnELSvJtiKlaFnNacktoz1x2hu/sScAKiby5Ch/tkYJRAkD1tqA9AXR19tl4Coa98hJiewiIyVlXHsmNVl0D15v0JuxcOw5bCfpZ/Y7dHB/uEIRSIg0wFStxqF6jcHzqh6rf2+9KrmM=
Message-ID: <47FEFFC6.4@gmail.com>
Date: Fri, 11 Apr 2008 15:05:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804030704.21480.volker.armin.hemmann@tu-clausthal.de> <47F46A74.504@gmail.com> <200804031347.20352.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200804031347.20352.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Armin Hemmann wrote:
> From systemrescuecd, ahci in bios, no nomsi:
>            CPU0       CPU1       
>   0:        147          1   IO-APIC-edge      timer
>   1:          0        607   IO-APIC-edge      i8042
>   8:          0         61   IO-APIC-edge      rtc
>   9:          0          1   IO-APIC-fasteoi   acpi
>  12:          0          4   IO-APIC-edge      i8042
>  14:          0          0   IO-APIC-edge      libata
>  15:          0          0   IO-APIC-edge      libata
>  18:          0         16   IO-APIC-fasteoi   aic7xxx
>  21:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
>  22:          2       8428   IO-APIC-fasteoi   ehci_hcd:usb1
> 1274:          0          0   PCI-MSI-edge      ahci
> 1275:          0        222   PCI-MSI-edge      eth0
> NMI:          0          0   Non-maskable interrupts
> LOC:      14777      16785   Local timer interrupts
> RES:       7250       6100   Rescheduling interrupts
> CAL:         41         52   function call interrupts
> TLB:       1866       1876   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          6
> 
> With my 'own' kernel, AHCI has interrupt 315. I will try and make a more 
> monolithic kernel so I might be able to boot from a usb-flash device.
> .
> .
> .
> which didn't work. Hm, I am too stupid for that today...

Hmmm...

>>> I will reboot from systemresucecd later today and post some results with
>>> ahci-mode set, no nomsi. Just can't try patches that way.
>> Is sytemrescuecd using the same kernel?  Otherwise, it will only add
>> more to the confusion.
> 
> almost.  A heavily patched 2.6.24.2. That is why I don't sent a dmesg ... just 
> cat /proc/interrupts. I can send you lspci -vv and dmesg from systemrescuecd 
> if you want.

Aiee.... Can you please try 2.6.25-rc8 with both configurations?  And 
w/o systemrescuecd?  Just seeing whether things mount properly or not is 
good enough.  There isn't much risk of losing data.

-- 
tejun
