Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab0CMJBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:01:38 -0500
Received: from lucidpixels.com ([75.144.35.66]:49684 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933864Ab0CMJBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:01:34 -0500
Date: Sat, 13 Mar 2010 04:01:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
  reboots [now 2.6.34-rc1]
In-Reply-To: <4B9AB7AE.7000002@kernel.org>
Message-ID: <alpine.DEB.2.00.1003121859240.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
 <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan> <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan> <alpine.DEB.2.00.1003121622470.6929@p34.internal.lan> <4B9AB717.3050608@kernel.org>
 <alpine.DEB.2.00.1003121651460.6929@p34.internal.lan> <4B9AB7AE.7000002@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Mar 2010, Yinghai Lu wrote:

> On 03/12/2010 01:52 PM, Justin Piszcz wrote:
>>
>>
>> On Fri, 12 Mar 2010, Yinghai Lu wrote:
>>
>>> On 03/12/2010 01:30 PM, Justin Piszcz wrote:
>>>>
>>>>
>>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>>
>>>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>>>
>>>>
>>>> # Disable Bootmem code (NO_BOOTMEM) [Y/n/?] (NEW)
>>>>
> should be ok, just some warning.

Hi,

It stayed up for approximately 8-9 hours, then it crashed again.

It is either a DOA motherboard OR the memory mapping is causing problems..

$ cat /proc/interrupts
            CPU0       CPU1
   0:        127          8   IO-APIC-edge      timer
   1:          0          8   IO-APIC-edge      i8042
   8:          1         92   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  14:          9       2353   IO-APIC-edge      pata_atiixp
  15:          2         39   IO-APIC-edge      pata_atiixp
  16:          0          0   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4
  17:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
  18:          0         68   IO-APIC-fasteoi   ahci, ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
  19:          0          0   IO-APIC-fasteoi   pata_jmicron, ehci_hcd:usb2
  22:          1         85   IO-APIC-fasteoi   ahci
  27:         34       9902   PCI-MSI-edge      eth1
  28:         39      11356   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:    2278016    2277635   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:       3805       2872   Rescheduling interrupts
CAL:         23        138   Function call interrupts
TLB:          9          5   TLB shootdowns
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          8          8   Machine check polls
ERR:          0
MIS:          0

Any other thoughts/ideas/things to try?

Justin.

