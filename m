Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYA3Rp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYA3Rp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYA3RpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:45:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51380 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYA3RpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:45:18 -0500
Date: Wed, 30 Jan 2008 09:44:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: ioremap_xxx() with EXEC enabled
Message-ID: <20080130094427.720fdae7@laptopd505.fenrus.org>
In-Reply-To: <20080130173048.GA9812@bingen.suse.de>
References: <1201685530.17912.11.camel@caritas-dev.intel.com>
	<20080130074540.031b6799@laptopd505.fenrus.org>
	<20080130173048.GA9812@bingen.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 18:30:48 +0100
Andi Kleen <ak@suse.de> wrote:

> On Wed, Jan 30, 2008 at 07:45:40AM -0800, Arjan van de Ven wrote:
> > On Wed, 30 Jan 2008 17:32:10 +0800
> > "Huang, Ying" <ying.huang@intel.com> wrote:
> > 
> > > Hi,
> > > 
> > > On i386, EFI may need to map EFI runtime code area as EXEC enabled
> > > with ioremap(). But, I found that the memory are mapped as EXEC
> > > disabled when mapped with ioremap() now. I think we may need a
> > > method to map memory area as EXEC enabled with ioremap_xxx().
> > > Some possible interface schemes for mapping as EXEC enabled are
> > > as follow:
> > > 
> > > - Interface scheme 1:
> > 
> > scheme 3:
> > 
> > set_memory_x(... )
> 
> On i386 EFI is unlikely to be in the direct mapping ...

1) 32 bit EFI is totally irrelevant.
2) set_memory_ and set_pages_ API is not restricted to direct mapping. That's why they take a virtual address / struct page

> 
> -Andi
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
