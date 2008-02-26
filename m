Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbYBZJUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbYBZJUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbYBZJUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:20:39 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52007 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbYBZJUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:20:38 -0500
Date: Tue, 26 Feb 2008 11:19:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is "pci_find_subsys" safe to remove?
Message-ID: <20080226091935.GB3498@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0802251713050.24343@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802251713050.24343@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 05:15:25PM -0500, Robert P. J. Day wrote:
> 
>   it's not just that it falls under the category of PCI "legacy" but,
> if you look in drivers/pci/search.c near the bottom:
> 
> ...
> #ifdef CONFIG_PCI_LEGACY
> EXPORT_SYMBOL(pci_find_device);
> EXPORT_SYMBOL(pci_find_slot);
> #endif /* CONFIG_PCI_LEGACY */
> ...
> 
> that symbol is not being exported even *if* you select PCI_LEGACY.
> i'm guessing that's an oversight but it would certainly suggest that
> no one can possibly be using it, no?

It's used by pci_find_device().

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

