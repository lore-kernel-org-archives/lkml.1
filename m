Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYL2MxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYL2MxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYL2Mwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:52:40 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55106 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbYL2Mwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:52:39 -0500
Date: Mon, 29 Dec 2008 13:54:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
Message-ID: <20081229125411.GA1852@uranus.ravnborg.org>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229121218.GB9628@elte.hu> <20081229122251.GA13687@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229122251.GA13687@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> btw., you missed to update a couple of places - pci/pci.h was used outside 
> of arch/x86 as well. Updated patch below.
> 
> 	Ingo
> 
> ---------------->
> >From 54a090abe7cb85c724305124f57d2570b7e9adf1 Mon Sep 17 00:00:00 2001
> From: Jaswinder Singh Rajput <jaswinder@infradead.org>
> Date: Sat, 27 Dec 2008 18:32:28 +0530
> Subject: [PATCH] x86, pci: move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
> 
> Impact: cleanup
> 
> Now that arch/x86/pci/pci.h is used in a number of other places as well,
> move the lowlevel x86 pci definitions into the architecture include files.
> (not to be confused with the existing arch/x86/include/asm/pci.h file,
> which provides public details about x86 PCI)
> 
> Tested on: X86_32_UP, X86_32_SMP and X86_64_SMP
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/pci_x86.h     |  165 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/mmconf-fam10h_64.c |    3 +-
>  arch/x86/kernel/reboot.c           |    3 +-
>  arch/x86/pci/acpi.c                |    2 +-
>  arch/x86/pci/amd_bus.c             |    2 +-
>  arch/x86/pci/common.c              |    3 +-
>  arch/x86/pci/direct.c              |    2 +-
>  arch/x86/pci/early.c               |    2 +-
>  arch/x86/pci/fixup.c               |    3 +-
>  arch/x86/pci/i386.c                |    2 +-
>  arch/x86/pci/init.c                |    2 +-
>  arch/x86/pci/irq.c                 |    3 +-
>  arch/x86/pci/legacy.c              |    2 +-
>  arch/x86/pci/mmconfig-shared.c     |    3 +-
>  arch/x86/pci/mmconfig_32.c         |    2 +-
>  arch/x86/pci/mmconfig_64.c         |    3 +-
>  arch/x86/pci/numaq_32.c            |    2 +-
>  arch/x86/pci/olpc.c                |    2 +-
>  arch/x86/pci/pcbios.c              |    5 +-
>  arch/x86/pci/pci.h                 |  162 -----------------------------------
>  arch/x86/pci/visws.c               |    3 +-
>  drivers/pci/hotplug/cpqphp_core.c  |    2 +-
>  drivers/pci/hotplug/cpqphp_pci.c   |    2 +-
>  drivers/pci/hotplug/ibmphp_core.c  |    2 +-
>  24 files changed, 188 insertions(+), 194 deletions(-)

You should teach your script to use:
git format-patch -M -B -C 

With -M -B -C you get a much better picture of what happens when you rename
files like in this patch (and copy them).

	Sam
