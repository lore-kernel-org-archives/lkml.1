Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXLUBfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXLUBfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXLUBfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:35:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXLUBfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:35:36 -0500
Message-ID: <476B185D.3000409@redhat.com>
Date: Thu, 20 Dec 2007 20:35:25 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       Prarit Bhargava <prarit@redhat.com>, bnagendr@redhat.com
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca>
In-Reply-To: <476B0C58.4030703@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> First off, I would like to see confirmation from the horses's mouths 
> here (namely AMD, ServerWorks/Broadcom, and whoever else) that there is 
> no other way to get around this problem than disabling MMCONFIG for 
> accesses behind those chips.
> 

I happen to have this one stored in my desktop.

 From AMD-8132TM HyperTransportTM
      PCI-X®2.0 Tunnel
       Revision Guide

http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30801.pdf

79 AMD-8132TM Tunnel Lacks Extended Configuration
         Space Memory-Mapped I/O Base Address Register

Description

Current AMD processors do not natively support PCI-defined extended configuration space. A memory
mapped I/O base address register (MMIO BAR) is required in chipset devices to support extended
configuration space. The AMD-8132 does not have this MMIO BAR.
Potential Effect On System

The AMD-8132 is a PCI-X® Mode 2 capable device and requires the MMIO BAR to support extended
configuration space. Using a device which does have this MMIO BAR and an AMD-8132 on the same
HyperTransportTM link of the processor may cause firmware/software problems.

The base configuration space of the AMD-8132 and PCI(-X) devices attached to it are accessible using only
the mechanism defined in PCI 2.3. Registers of PCI-X Mode 2 devices attached to the AMD-8132 in the
extended configuration space are not accessible. The AMD-8132 has no registers in the extended
configuration space.

Suggested Workaround

It is strongly recommended that system designers do not connect the AMD-8132 and devices that use extended
configuration space MMIO BARs (ex: HyperTransport-to-PCI Express® bridges) to the same processor
HyperTransport link.

Fix Planned
No

