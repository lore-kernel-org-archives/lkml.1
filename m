Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbYBNVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbYBNVXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYBNVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:23:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:52433 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751433AbYBNVXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:23:02 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/NXf9l7uTNEd18UnBOIFrs587yO3VpmpRRfLq2b5
	G1D32JxebZ1Iqr
Date: Thu, 14 Feb 2008 22:23:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [ACPI X86_64] 2.6.24 doesn't boot on a Core 2 Duo
In-Reply-To: <Pine.LNX.4.64.0802142121040.7981@axis700.grange>
Message-ID: <Pine.LNX.4.64.0802142219300.7981@axis700.grange>
References: <Pine.LNX.4.64.0802142121040.7981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Guennadi Liakhovetski wrote:

> 2.6.24.2 fails to boot on the above system with an Intel DQ35JO 
> motherboard, as do Debian install kernels - both stock etch amd64 and 
> updated image from Kenshi Muto (kmuto.jp). The only way to boot was with 
> "acpi=off". Whereas ubuntu 7.10 amd64 2.6.22-based boot-CD boots without 
> problems. Below is ubuntu's dmesg with a place marked where Debian and 
> self-compiled vanilla 2.6.24.2 kernels hang. Tried "pci=noacpi", 
> "acpi=noirq", "noapic", "nolapic", "pci=routeirq" with no success.

Found this page:

http://www.linuxquestions.org/questions/slackware-installation-40/cddvd-not-found-584582/page2.html

and a solution therein: "pci=nommconf" or disable CONFIG_PCI_MMCONFIG. 
Now, I don't understand why PCI_MMCONFIG is twice in ./arch/x86/Kconfig 
and maybe one has to be a bit more careful when defaulting it to "y".

Thanks
Guennadi
---
Guennadi Liakhovetski
