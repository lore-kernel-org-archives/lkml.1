Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZBIBVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZBIBVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZBIBUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:20:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:39849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZBIBUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:20:51 -0500
Date: Sun, 8 Feb 2009 17:21:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.29-rc4
Message-ID: <20090208172111.6941cd3e@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009 13:01:04 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Another week (and a half), another -rc.
> 
> Arch updates (sparc, blackfin), driver updates (dvb, mmc, ide), ACPI 
> updates, FS updates (ubifs, btrfs), you name it. It's all there.
> 
> But more importantly, people really have been working on regressions,
> and hopefully this closes a nice set of the top one, and hopefully
> without introducing too many new ones.
> 
> 			Linus


I just looked at the top -rc3 oopses/warnings/etc

quick summary of the top ones:
(manual rather than the normal automated scripts, so the format is
different)
"regulars" that happened a lot prior to  .29 (eg clearly non-regressions) I marked with a *

Oopses: 78 oopses reported
--------------------------
12 times	i915_driver_irq_handler		http://www.kerneloops.org/searchweek.php?search=i915_driver_irq_handler
8 times		apic_mmio_read			http://www.kerneloops.org/searchweek.php?search=apic_mmio_read


BUG/BUG_ON:	16 reports
--------------------------
6 times		i915_gem_object_unpin		http://www.kerneloops.org/searchweek.php?i915_gem_object_unpin
2 times		__schedule			http://www.kerneloops.org/searchweek.php?__schedule


WARN/WARN_ON/etc:	999 reports
-----------------------------------
213 times	check_unmap			http://www.kerneloops.org/searchweek.php?search=check_unmap
164 times	last_sector_hacks		http://www.kerneloops.org/searchweek.php?search=last_sector_hack
94 times	*mpt_config			http://www.kerneloops.org/searchweek.php?search=mpt_config
92 times	reserve_pfn_range		http://www.kerneloops.org/searchweek.php?search=reserve_pfn_range
79 times	*init_ck804xrom			http://www.kerneloops.org/searchweek.php?search=init_ck804xrom
56 times	*iwl_set_dynamic_key		http://www.kerneloops.org/searchweek.php?search=iwl_set_dynamic_key
39 times	check_sync			http://www.kerneloops.org/searchweek.php?search=check_sync
35 times	track_pfn_vma_copy		http://www.kerneloops.org/searchweek.php?search=track_pfn_vma_cop

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
