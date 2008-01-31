Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbYAaQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbYAaQbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYAaQbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:31:03 -0500
Received: from www.tglx.de ([62.245.132.106]:50657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760941AbYAaQbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:31:00 -0500
Date: Thu, 31 Jan 2008 17:30:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
In-Reply-To: <200801311427.38198.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0801311728430.9204@apollo.tec.linutronix.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com> <200801311427.38198.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andi Kleen wrote:
> > addr = ioremap(phys_addr, len);
> > set_memory_x(addr);
> > if (phys_addr < (end_pfn_mapped >> PAGE_SHIFT))
> >         set_memory_x(__va(phys_addr));
> 
> If you just need the ioremap executable there is no reason to split 
> up the direct mapping for this too. The x86 architecture does not require
> x bits to be coherent between mappings; only the caching attributes.

Thanks for pointing this out.

       tglx
