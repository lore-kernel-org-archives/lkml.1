Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYIWD6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYIWD6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYIWD6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:58:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:38725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYIWD6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:58:08 -0400
Date: Mon, 22 Sep 2008 20:58:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] raid: make RAID autodetect default a KConfig option
Message-ID: <20080922205808.033436f7@infradead.org>
In-Reply-To: <18648.26191.479291.883160@notabene.brown>
References: <20080921154541.371f2ebe@infradead.org>
	<20080922082728.GB6601@elte.hu>
	<18648.26191.479291.883160@notabene.brown>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 13:45:19 +1000
Neil Brown <neilb@suse.de> wrote:

> On Monday September 22, mingo@elte.hu wrote:
> > 
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > From 812bf9a448d96375a3aec5c51764d74cace85abb Mon Sep 17 00:00:00
> > > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Sun, 21 Sep 2008 15:44:32 -0700
> > > Subject: [PATCH] raid: make RAID autodetect default a KConfig
> > > option
> > > 
> > > RAID autodetect has the side effect of requiring synchronisation
> > > of all device drivers, which can make the boot several seconds
> > > longer (I've measured 7 on one of my laptops).... even for
> > > systems that don't have RAID setup for the root filesystem (the
> > > only FS where this matters).
> > > 
> > > This patch makes the default for autodetect a config option;
> > > either way the user can always override via the kernel command
> > > line.
> > 
> > Neil, if you agree with this patch, could you please send your
> > Acked-by line? This patch depends on a clean-up in
> > init/do_mounts_md.c that is in the fastboot tree so it would be
> > logistically easier/better if we could queue this up towards
> > upstream via tip/fastboot.
> 
> Yes,
>  Acked-by: NeilBrown <neilb@suse.de>
> 
> I'm not a big fan of autodetect in any case, and this patch seems to
> cover all the bases I can think of.
> 

thanks
pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
master

Ingo, please pull


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
