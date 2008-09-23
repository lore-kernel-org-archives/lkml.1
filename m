Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYIWDpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYIWDpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYIWDpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:45:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:33132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYIWDpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:45:22 -0400
From: Neil Brown <neilb@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 23 Sep 2008 13:45:19 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18648.26191.479291.883160@notabene.brown>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] raid: make RAID autodetect default a KConfig option
In-Reply-To: message from Ingo Molnar on Monday September 22
References: <20080921154541.371f2ebe@infradead.org>
	<20080922082728.GB6601@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday September 22, mingo@elte.hu wrote:
> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > From 812bf9a448d96375a3aec5c51764d74cace85abb Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sun, 21 Sep 2008 15:44:32 -0700
> > Subject: [PATCH] raid: make RAID autodetect default a KConfig option
> > 
> > RAID autodetect has the side effect of requiring synchronisation of 
> > all device drivers, which can make the boot several seconds longer 
> > (I've measured 7 on one of my laptops).... even for systems that don't 
> > have RAID setup for the root filesystem (the only FS where this 
> > matters).
> > 
> > This patch makes the default for autodetect a config option; either 
> > way the user can always override via the kernel command line.
> 
> Neil, if you agree with this patch, could you please send your Acked-by 
> line? This patch depends on a clean-up in init/do_mounts_md.c that is in 
> the fastboot tree so it would be logistically easier/better if we could 
> queue this up towards upstream via tip/fastboot.

Yes,
 Acked-by: NeilBrown <neilb@suse.de>

I'm not a big fan of autodetect in any case, and this patch seems to
cover all the bases I can think of.

Thanks,
NeilBrown
