Return-Path: <linux-kernel-owner+w=401wt.eu-S1422926AbXDRMIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422926AbXDRMIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422938AbXDRMIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:08:42 -0400
Received: from duempel.org ([81.209.165.42]:38654 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422926AbXDRMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:08:41 -0400
Date: Wed, 18 Apr 2007 14:08:05 +0200
From: Max Kellermann <max@duempel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
Message-ID: <20070418120805.GA16989@roonstrasse.net>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20070418061541.GA11293@roonstrasse.net> <4625BA1A.9030808@gmail.com> <20070418074859.GA21494@roonstrasse.net> <4625CF43.5010704@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <4625CF43.5010704@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2007/04/18 09:56, Tejun Heo <htejun@gmail.com> wrote:
> It's more likely your chipset just has busted MSI support.  Please
> post the result of 'lspci -tv' and 'lspci -nn'.

See attachments.  I found the "nomsi" workaround in a forum, and
didn't bother to investigate the real cause yet.

Max


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci_tv.txt"

-[0000:00]-+-00.0  VIA Technologies, Inc. VT3351 Host Bridge
           +-00.1  VIA Technologies, Inc. VT3351 Host Bridge
           +-00.2  VIA Technologies, Inc. VT3351 Host Bridge
           +-00.3  VIA Technologies, Inc. VT3351 Host Bridge
           +-00.4  VIA Technologies, Inc. VT3351 Host Bridge
           +-00.5  VIA Technologies, Inc. VT3351 I/O APIC Interrupt Controller
           +-00.7  VIA Technologies, Inc. VT3351 Host Bridge
           +-01.0-[0000:01]--
           +-02.0-[0000:02]--
           +-03.0-[0000:03]--
           +-0f.0  VIA Technologies, Inc. VT8251 AHCI/SATA 4-Port Controller
           +-0f.1  VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE
           +-10.0  VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
           +-10.1  VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
           +-10.2  VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
           +-10.3  VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
           +-10.4  VIA Technologies, Inc. USB 2.0
           +-11.0  VIA Technologies, Inc. VT8251 PCI to ISA Bridge
           +-11.7  VIA Technologies, Inc. VT8251 Ultra VLINK Controller
           +-12.0  VIA Technologies, Inc. VT6102 [Rhine-II]
           +-13.0-[0000:04-06]--+-00.0-[0000:05]--
           |                    \-00.1-[0000:06]--
           +-13.1-[0000:07]--+-0b.0  Matrox Graphics, Inc. MGA 2064W [Millennium]
           |                 +-0c.0  Intel Corporation 82546GB Gigabit Ethernet Controller
           |                 +-0c.1  Intel Corporation 82546GB Gigabit Ethernet Controller
           |                 \-0d.0  Promise Technology, Inc. PDC40718 (SATA 300 TX4)
           +-18.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-18.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci_nn.txt"

00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:0351]
00:00.1 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:1351]
00:00.2 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:2351]
00:00.3 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:3351]
00:00.4 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:4351]
00:00.5 PIC [0800]: VIA Technologies, Inc. VT3351 I/O APIC Interrupt Controller [1106:5351]
00:00.7 Host bridge [0600]: VIA Technologies, Inc. VT3351 Host Bridge [1106:7351]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. [K8T890 North / VT8237 South] PCI Bridge [1106:b999]
00:02.0 PCI bridge [0604]: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller [1106:a238]
00:03.0 PCI bridge [0604]: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller [1106:c238]
00:0f.0 RAID bus controller [0104]: VIA Technologies, Inc. VT8251 AHCI/SATA 4-Port Controller [1106:3349]
00:0f.1 IDE interface [0101]: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev 07)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.4 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 90)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8251 PCI to ISA Bridge [1106:3287]
00:11.7 Host bridge [0600]: VIA Technologies, Inc. VT8251 Ultra VLINK Controller [1106:287e]
00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102 [Rhine-II] [1106:3065] (rev 7c)
00:13.0 PCI bridge [0604]: VIA Technologies, Inc. VT8251 Host Bridge [1106:287b]
00:13.1 PCI bridge [0604]: VIA Technologies, Inc. VT8251 PCI to PCI Bridge [1106:287a]
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
04:00.0 PCI bridge [0604]: VIA Technologies, Inc. VT8251 PCIE Root Port [1106:287c]
04:00.1 PCI bridge [0604]: VIA Technologies, Inc. VT8251 PCIE Root Port [1106:287d]
07:0b.0 VGA compatible controller [0300]: Matrox Graphics, Inc. MGA 2064W [Millennium] [102b:0519] (rev 01)
07:0c.0 Ethernet controller [0200]: Intel Corporation 82546GB Gigabit Ethernet Controller [8086:1079] (rev 03)
07:0c.1 Ethernet controller [0200]: Intel Corporation 82546GB Gigabit Ethernet Controller [8086:1079] (rev 03)
07:0d.0 Mass storage controller [0180]: Promise Technology, Inc. PDC40718 (SATA 300 TX4) [105a:3d17] (rev 02)

--fUYQa+Pmc3FrFX/N--
