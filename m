Return-Path: <linux-kernel-owner+w=401wt.eu-S1161047AbXAaVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047AbXAaVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXAaVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:47:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:14545 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161047AbXAaVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:47:43 -0500
Date: Wed, 31 Jan 2007 13:40:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Fix apparent typo of "CONFIG_MT_SMP".
Message-Id: <20070131134006.03b8b89c.randy.dunlap@oracle.com>
In-Reply-To: <45C10B68.4050002@redhat.com>
References: <Pine.LNX.4.64.0701251839140.15699@CPE00045a9c397f-CM001225dbafb6>
	<45C10B68.4050002@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 16:34:32 -0500 Chuck Ebbert wrote:

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

It's here:
  http://www.fsdev.dreamhosters.com/wiki/index.php?title=Dead_CONFIG_variables

---
~Randy
