Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYDAN3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYDAN3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYDAN31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:29:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYDAN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:29:27 -0400
Date: Tue, 1 Apr 2008 15:33:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: scary messages are fortunately obsolete
Message-ID: <20080401133313.GK29105@one.firstfloor.org>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113508.GP29105@one.firstfloor.org> <20080401122403.GC12129@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401122403.GC12129@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	/* Should not happen anymore */
> -	printk(KERN_ERR "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
> -	       KERN_ERR "PCI-DMA: 32bit PCI IO may malfunction.\n");
> +	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
> +	       KERN_WARNING "falling back to iommu=soft.\n");

It might also fall back to another IOMMU (Calgary, Intel, ...) 
soft is just last resort.

You can probably just remove it.

-Andi
