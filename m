Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbYENIKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbYENIKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYENIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:10:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757819AbYENIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:10:11 -0400
Date: Wed, 14 May 2008 01:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Goldner <robert@au-79.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Problems with mainboard INTEL D201GLY2A, pci devices only
 available with acpi=noirq
Message-Id: <20080514011007.58f9be4a.akpm@linux-foundation.org>
In-Reply-To: <482A7F92.8030504@au-79.de>
References: <482A7F92.8030504@au-79.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 07:58:42 +0200 Robert Goldner <robert@au-79.de> wrote:

> I use a INTEL D201GLY2A mainboard, and after serveral trys PCI devices 
> were only useable (not visable) with the boot-parameter acpi=noirq (or 
> noacpi). I tryed several kernel-versions (stated with 2.6.22), and no 
> sucess without his parameter.
> Without acpi=noirq all pci devices are deteced well, but if you want to 
> use them, there is no response.
> 
> So, now some (as I thnik) relevant informations:
> lspci
> 00:00.0 Host bridge: Silicon Integrated Systems [SiS] 662 Host (rev 01)
> 00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port
> 00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL
> 00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev
> 00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
> 00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
> 00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
> 00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
> 00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0
> 00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI
> 00:05.0 IDE interface: Silicon Integrated Systems [SiS] SATA (rev 01)
> 00:06.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213
> 00:1f.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge
> 01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
> 
> 
> .config (I did not attach all information about drivers, because I don__t 
> think that this is relevant)

Probably your best approach will be to raise a report against acpi at
bugzilla.kernel.org, please.  These things do get fixed, but it takes
some time.

Thanks.
