Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYF0Crp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYF0Crp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYF0Crg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:47:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:32708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYF0Crf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,713,1204531200"; 
   d="scan'208";a="346127454"
Subject: Re: [PATCH 00/16] x86: merge setup_32/64.c
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Huang@elte.hu, Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <20080626110113.GA14513@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <20080626094743.GA19573@elte.hu> <20080626100200.GA15291@elte.hu>
	 <86802c440806260306o419f2369od90f1cb3c801311e@mail.gmail.com>
	 <20080626110113.GA14513@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Jun 2008 10:51:09 +0800
Message-Id: <1214535069.10865.10.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 27 Jun 2008 02:47:19.0156 (UTC) FILETIME=[1DCBE340:01C8D800]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 13:01 +0200, Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > >  #include <asm/mpspec.h>
> > >  #include <asm/setup.h>
> > >  #include <asm/arch_hooks.h>
> > > +#include <asm/efi.h>
> > >  #include <asm/sections.h>
> > >  #include <asm/dmi.h>
> > >  #include <asm/io_apic.h>
> > 
> > checkpatch.pl want me to remove that.
> 
> checkpatch.pl is right about that, but the proper fix would be to decode 
> this dependency - why isnt it enough to include linux/efi.h?

There is one dependency for asm/efi.h: declaration of
efi_reserve_early(). This declaration can be moved to linux/efi.h, maybe
after being renamed to efi_reserve_memmap().

Best Regards,
Huang Ying

