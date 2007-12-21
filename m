Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXLUEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXLUEH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXLUEHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:07:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXLUEHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:07:21 -0500
Message-ID: <476B3BE7.10105@redhat.com>
Date: Thu, 20 Dec 2007 23:07:03 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Loic Prylli <loic@myri.com>
CC: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       Prarit Bhargava <prarit@redhat.com>, bnagendr@redhat.com
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca> <476B185D.3000409@redhat.com> <476B21D8.2030602@shaw.ca> <476B35BC.8060204@myri.com>
In-Reply-To: <476B35BC.8060204@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli wrote:
> 
> Just curious, do you know of any system where that recommendation was
> not followed? On all motherboards where I have seen a AMD-8131 or a
> AMD-8132, they were alone on their hypertransport link, and other
> "northbridges" (more precisely hypertransport to pci-express or
> pci-whatever, often nvidia) with a "MMCONFIG BAR" where on one of the
> other available hypertransport links in the system.
> 
> 
> Loic
> 

Here is the PCI configuration of the HP DL585G2.

You can see two nVidia CK804 PCIE root ports at bus 0 and bus 0x40.
Each of them has an 8132 connected as a subordinate bridge.

[root@hp-dl585g2-01 ~]# lspci -vt
-+-[0000:40]-+-00.0  nVidia Corporation CK804 Memory Controller
  |           +-01.0  nVidia Corporation CK804 Memory Controller
  |           +-0b.0-[0000:4f-51]--
  |           +-0c.0-[0000:4c-4e]--
  |           +-0d.0-[0000:49-4b]--
  |           +-0e.0-[0000:46-48]--
  |           +-10.0-[0000:41]--+-01.0  Broadcom Corporation NetXtreme II BCM5706 Gigabit Ethernet
  |           |                 \-02.0  Broadcom Corporation NetXtreme II BCM5706 Gigabit Ethernet
  |           +-10.1  Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC
  |           +-11.0-[0000:42-45]--
  |           \-11.1  Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC
  \-[0000:00]-+-00.0  nVidia Corporation CK804 Memory Controller
              +-01.0  nVidia Corporation CK804 ISA Bridge
              +-02.0  nVidia Corporation CK804 USB Controller
              +-02.1  nVidia Corporation CK804 USB Controller
              +-06.0  nVidia Corporation CK804 IDE
              +-09.0-[0000:01]--+-03.0  ATI Technologies Inc ES1000
              |                 +-04.0  Compaq Computer Corporation Integrated Lights Out Controller
              |                 +-04.2  Compaq Computer Corporation Integrated Lights Out  Processor
              |                 +-04.4  Hewlett-Packard Company Proliant iLO2 virtual USB controller
              |                 \-04.6  Hewlett-Packard Company Proliant iLO2 virtual UART
              +-0c.0-[0000:08-0a]----00.0  Hewlett-Packard Company Smart Array Controller
              +-0d.0-[0000:05-07]--
              +-0e.0-[0000:02-04]--
              +-18.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
              +-18.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
              +-18.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
              +-18.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
              +-19.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
              +-19.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
              +-19.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
              +-19.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
              +-1a.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
              +-1a.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
              +-1a.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
              +-1a.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
              +-1b.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
              +-1b.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
              +-1b.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
              \-1b.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
[root@hp-dl585g2-01 ~]#













