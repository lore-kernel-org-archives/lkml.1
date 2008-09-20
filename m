Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYITLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYITLl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYITLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:41:51 -0400
Received: from ptb-relay01.plus.net ([212.159.14.145]:44001 "EHLO
	ptb-relay01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYITLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:41:51 -0400
Message-ID: <48D4E180.4050907@yahoo.com>
Date: Sat, 20 Sep 2008 12:41:52 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <48D4CFA5.7010501@suse.de> <48D4D5CA.1060104@yahoo.com> <48D4D6AE.70705@yahoo.com> <48D4DB23.5080901@suse.de> <48D4DD3C.3050308@yahoo.com>
In-Reply-To: <48D4DD3C.3050308@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 4cf84bf39d29af61dba4245be1da69ea
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Alexey Starikovskiy wrote:
>> Could you cat /proc/interrupts ?
> 
>            CPU0
>   0:     106942   IO-APIC-edge      timer
>   1:        426   IO-APIC-edge      i8042
>   8:         41   IO-APIC-edge      rtc0
>   9:      27346   IO-APIC-fasteoi   acpi
>  12:       6840   IO-APIC-edge      i8042
>  14:          0   IO-APIC-edge      ata_piix
>  15:        203   IO-APIC-edge      ata_piix
>  16:      92357   IO-APIC-fasteoi   uhci_hcd:usb5, HDA Intel, 
> i915@pci:0000:00:02.0
>  18:      38195   IO-APIC-fasteoi   ath, uhci_hcd:usb4
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  23:      25150   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> NMI:          0   Non-maskable interrupts
> LOC:     142112   Local timer interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0

and here are the interrupts from the (seemingly working) EeePC's Xandros 
2.6.21.4 install:

            CPU0
   0:       6486    XT-PIC-XT        timer
   1:        107    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   3:          0    XT-PIC-XT        uhci_hcd:usb2
   5:        735    XT-PIC-XT        uhci_hcd:usb1, ehci_hcd:usb5
   9:        219    XT-PIC-XT        acpi
  10:       8171    XT-PIC-XT        uhci_hcd:usb3, pciehp, wifi0
  11:        107    XT-PIC-XT        HDA Intel, i915@pci:0000:00:02.0, 
uhci_hcd:usb4, pciehp
  12:        236    XT-PIC-XT        i8042
  14:          0    XT-PIC-XT        libata
  15:       3475    XT-PIC-XT        libata
NMI:          0
ERR:          0

and here is the kernel cmdline that the Xandros install uses:
quiet rw vga=785 irqpoll root=/dev/sda1

I've got a feeling I know what direction this is going in...

-- 
Sitsofe | http://sucs.org/~sits/
