Return-Path: <linux-kernel-owner+w=401wt.eu-S1763726AbYA3RbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763726AbYA3RbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYA3Rav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:30:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbYA3Rau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:30:50 -0500
Date: Wed, 30 Jan 2008 18:30:48 +0100
From: Andi Kleen <ak@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: ioremap_xxx() with EXEC enabled
Message-ID: <20080130173048.GA9812@bingen.suse.de>
References: <1201685530.17912.11.camel@caritas-dev.intel.com> <20080130074540.031b6799@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130074540.031b6799@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:45:40AM -0800, Arjan van de Ven wrote:
> On Wed, 30 Jan 2008 17:32:10 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
> > Hi,
> > 
> > On i386, EFI may need to map EFI runtime code area as EXEC enabled
> > with ioremap(). But, I found that the memory are mapped as EXEC
> > disabled when mapped with ioremap() now. I think we may need a method
> > to map memory area as EXEC enabled with ioremap_xxx(). Some possible
> > interface schemes for mapping as EXEC enabled are as follow:
> > 
> > - Interface scheme 1:
> 
> scheme 3:
> 
> set_memory_x(... )

On i386 EFI is unlikely to be in the direct mapping ...

-Andi

