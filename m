Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYFQJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYFQJDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYFQJDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:03:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58956 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYFQJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:03:07 -0400
Date: Tue, 17 Jun 2008 12:01:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Grant Grundler <grundler@parisc-linux.org>, ink@jurassic.park.msu.ru
Cc: kyle@mcmartin.ca, matthew@wil.cx, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: parisc: pcibios_init_bus() isn't called
Message-ID: <20080617090143.GB20169@cs181133002.pp.htv.fi>
References: <20080615161327.GC7865@cs181133002.pp.htv.fi> <20080616224107.GA32030@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080616224107.GA32030@colo.lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 04:41:07PM -0600, Grant Grundler wrote:
> On Sun, Jun 15, 2008 at 07:13:27PM +0300, Adrian Bunk wrote:
> > arch/parisc/kernel/pci.c:pcibios_init_bus() never gets called - this
> > doesn't seem to be intentionally?
> 
> I think this is accidentally abandoned code and introduced here:
>     http://lkml.org/lkml/2001/12/22/43

As far as I can see this patch never made it into the tree?

Ivan, do you remember details about this?

> So it was called from pci_do_scan_bus(). Can you track down when this
> was removed from pci_do_scan_bus() ?
> 
> But it was once used by parisc port:
>     http://lists.parisc-linux.org/pipermail/parisc-linux/2001-June/037259.html
> 
> and then perhaps got removed soon after in the generic code:
>     http://www.cs.helsinki.fi/linux/linux-kernel/2003-01/0388.html
> 
> But I'm not finding the exact patch that removed it.
> 
> thanks,
> grant

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

