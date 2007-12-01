Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbXLAUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbXLAUCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXLAUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:02:04 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34821 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752132AbXLAUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:02:01 -0500
Date: Sat, 1 Dec 2007 21:01:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-git4 build warnings
Message-ID: <20071201200153.GD15974@stusta.de>
References: <200711291419.49261.chris2553@googlemail.com> <20071201193636.GC15974@stusta.de> <200712011949.46386.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712011949.46386.chris2553@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 07:49:46PM +0000, Chris Clayton wrote:
> On Saturday 01 December 2007, Adrian Bunk wrote:
> > On Thu, Nov 29, 2007 at 02:19:49PM +0000, Chris Clayton wrote:
> > > Hi,
> > >
> > > I've just built 2.6.24-rc3-git4 and got the following two warnings.
> > >
> > >   LD      .tmp_vmlinux1
> > >   KSYM    .tmp_kallsyms1.S
> > >   AS      .tmp_kallsyms1.o
> > >   LD      .tmp_vmlinux2
> > >   KSYM    .tmp_kallsyms2.S
> > >   AS      .tmp_kallsyms2.o
> > >   LD      vmlinux.o
> > >   MODPOST vmlinux.o
> > > WARNING: vmlinux.o(.text+0x90b6): Section mismatch: reference to
> > > .init.text:cache_remove_shared_cpu_map (between 'free_cache_attributes'
> > > and 'show_level')
> > > WARNING: vmlinux.o(.init.text+0x143bd): Section mismatch: reference to
> > > .exit.text:cpufreq_stats_free_table (between 'cpufreq_stat_cpu_callback'
> > > and 'cpufreq_stats_init')
> > >...
> >
> > You seem to be using gcc 3.3 or 3.4.
> 
> Yes, it's 3.3.6. README in the top-level kernel source directory says "Make 
> sure you have at least gcc 3.2 available", so that should be OK, shouldn't 
> it?
>...

Yes, that's OK and 3.3.6 is a supported compiler for the kernel.

> Chris

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

