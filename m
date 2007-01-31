Return-Path: <linux-kernel-owner+w=401wt.eu-S1161049AbXAaVwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbXAaVwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161051AbXAaVwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:52:40 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:52054 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161049AbXAaVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:52:39 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 16:50:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Chuck Ebbert <cebbert@redhat.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Fix apparent typo of "CONFIG_MT_SMP".
In-Reply-To: <45C10B68.4050002@redhat.com>
Message-ID: <Pine.LNX.4.64.0701311645180.8375@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701251839140.15699@CPE00045a9c397f-CM001225dbafb6>
 <45C10B68.4050002@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Chuck Ebbert wrote:

> Robert P. J. Day wrote:
> >   Replace apparent typo of CONFIG_MT_SMP with CONFIG_MIPS_MT_SMP.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> > diff --git a/arch/mips/mips-boards/sim/sim_setup.c b/arch/mips/mips-boards/sim/sim_setup.c
> > index 2659c1c..ea2066c 100644
> > --- a/arch/mips/mips-boards/sim/sim_setup.c
> > +++ b/arch/mips/mips-boards/sim/sim_setup.c
> > @@ -57,7 +57,7 @@ void __init plat_mem_setup(void)
> >  	board_time_init = sim_time_init;
> >  	prom_printf("Linux started...\n");
> >
> > -#ifdef CONFIG_MT_SMP
> > +#ifdef CONFIG_MIPS_MT_SMP
> >  	sanitize_tlb_entries();
> >  #endif
> >  }
> >
> >
> Have you posted the latest version of your scripts for finding these?

it's available online:

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Dead_CONFIG_variables

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
