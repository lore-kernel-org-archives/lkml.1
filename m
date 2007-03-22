Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXCVTy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXCVTy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934207AbXCVTy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:54:26 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:58528 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934206AbXCVTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:54:26 -0400
Date: Thu, 22 Mar 2007 20:54:25 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE Erros
Message-ID: <20070322195425.GB19732@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070322195043.GA19732@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322195043.GA19732@cip.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.14 (2007-02-23)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>         MCE 0
>         HARDWARE ERROR. This is *NOT* a software problem!
>         Please contact your hardware vendor
>         CPU 0 4 northbridge TSC edc587de6e99
>         ADDR 1001a0000
>           Northbridge GART error
>                bit61 = error uncorrected
>           TLB error 'generic transaction, level generic'
>         STATUS a40000000005001b MCGSTATUS 0

> I see this error exactly 8 times. What does 'GART' mean?

dict says GART means 'Graphics Address Remapping Table (AGP)' but I
don't see how that fits in the picture?

        (tomcat-01) [~] lspci
        00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
        00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
        00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
        00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
        00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
        00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
        00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
        00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
        00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
        00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
        00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
        00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
        00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
        00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
        00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
        00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
        00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
        01:03.0 RAID bus controller: 3ware Inc 7xxx/8xxx-series PATA/SATA-RAID (rev 01)
        02:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 03)
        02:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 03)
        03:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
        03:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
        03:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
        03:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 10)

        (tomcat-01) [~] dmesg | grep -i agp
        No AGP bridge found
        PCI-DMA: Disabling AGP.
        PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
        Linux agpgart interface v0.101 (c) Dave Jones

Greetings,
        Thomas
