Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXJ1TxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXJ1TxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbXJ1TxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:53:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbXJ1TxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:53:12 -0400
Date: Sun, 28 Oct 2007 12:48:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Barak Fargoun" <barak@neocleus.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <gregkh@suse.de>, "Barak Fargoun" <barak@neocleus.com>,
       "Guy Zana" <guy@neocleus.com>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071028124856.7599cb61@laptopd505.fenrus.org>
In-Reply-To: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 13:27:27 -0400
"Barak Fargoun" <barak@neocleus.com> wrote:

> Sorry, my mail client corrupted the previous mail containing the
> patch... it should be ok now...
> 
> Add a boot parameter (‘pci-mem-align’) which forces PCI memory
> regions to be aligned to 4K. 
> 
> This is very useful when developing an hypervisor, since in case we
> want to let native domains direct access to specific hardware, we
> don’t want PCI devices to share their memory region page with other
> devices. In Xen for example, PCI devices mmio resources are mapped by
> remapping complete pages (by Intel VT-d & the Neocleus pass-through
> patch for Xen).
> 
> Signed-off-by: Barak Fargoun     (barak@neocleus.com)
> ---
> Kernel version: 2.6.18	(since this is the kernel version used
> in Xen for Dom-0) ---


I appreciate that Xen is about 2 years behind the curve and only uses
2.6.18, but what do you expect us on this list to do with this patch?
2.6.18 is no longer maintained: it doesn't get -stable updates anymore.
(And if it did, I doubt this kind of change would be suitable for a
-stable release anyway)...

so the first step really is to make a patch against 2.6.24-rc or a
later git version.... because then and only then is your patch
something that anyone else here can DO something with ...

(it's like the tree in the forest... if a tree falls in a forest, but
everyone moved to a different forest 2 years ago, does it make a sound?)

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
