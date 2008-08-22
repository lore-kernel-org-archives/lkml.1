Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbYHVKTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbYHVKTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYHVKTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:19:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43087 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYHVKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:19:12 -0400
Date: Fri, 22 Aug 2008 12:19:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, len.brown@intel.com,
       arjan@linux.intel.com, bjorn.helgaas@hp.com, linux-acpi@vger.kernel.org,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: [PATCH 1/3] Introduce interface to report BIOS bugs
Message-ID: <20080822101910.GH6542@atrey.karlin.mff.cuni.cz>
References: <1219251726-24746-1-git-send-email-trenn@suse.de> <1219251726-24746-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219251726-24746-2-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 
> This is mostly needed for ACPI systems.
> ACPI introduces an endless amount of possible BIOS
> bugs like wrong values, missing functions, etc.
> The kernel has to sanity check all of them and should
> report BIOS bugs as such to the user.
> 
> ACPI is the main target, of course others, who already declare BIOS bugs,
> also benefit from this, e.g. PCI:
> arch/x86/pci/pcbios.c:
>    printk(KERN_WARNING "bios32_service(0x%lx): returned 0x%x -- BIOS bug!\n",
>    printk (KERN_ERR "PCI: BIOS BUG #%x[%08x] found\n",
> ...
> This one I stumbled over recently (when >4GB BIOS sets up IO mem for this
> device wrongly on some Dell notebooks):
>    ohci_hcd 0000:00:02.0: USB HC takeover failed!  (BIOS/SMM bug)

I like the idea... Plus, it would be cool to have message clearly
state if Linux could work around this problem. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
