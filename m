Return-Path: <linux-kernel-owner+w=401wt.eu-S1764986AbYAaQhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764986AbYAaQhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYAaQhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:37:31 -0500
Received: from www.tglx.de ([62.245.132.106]:43878 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbYAaQha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:37:30 -0500
Date: Thu, 31 Jan 2008 17:37:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
In-Reply-To: <20080131163022.GD25989@bingen.suse.de>
Message-ID: <alpine.LFD.1.00.0801311732420.9204@apollo.tec.linutronix.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com> <alpine.LFD.1.00.0801311720280.9204@apollo.tec.linutronix.de>
 <20080131163022.GD25989@bingen.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andi Kleen wrote:

> > There is nothing to fix. It works on virtual addresses. 
> > 
> > The __pa() in change_page_attr_addr() is only used to check for the
> > high alias mapping of the kernel, but the call to change_page_attr
> > uses the virtual address.
> 
> But __pa() doesn't work for ioremap ...

If it does not, then __pa() needs to be fixed, nothing else.

Thanks,
	tglx
