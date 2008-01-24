Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYAXRLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYAXRLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYAXRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:10:58 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58850 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYAXRK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:10:57 -0500
Date: Thu, 24 Jan 2008 19:09:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>, ralf@linux-mips.org
Subject: Re: [PATCH] x86:
	fix?unconditional?arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080124170924.GB4476@does.not.exist>
References: <200801171643.49301.michael-lists@free-electrons.com> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org> <200801232330.12331.michael-lists@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801232330.12331.michael-lists@free-electrons.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 11:30:11PM +0100, Michael Opdenacker wrote:
> On Friday 18 January 2008, Matt Mackall wrote:
> > 
> > Probably makes sense to define it right next to INPUT_PCSPKR in
> > drivers/input/Kconfig.
> > 
> > Then do the appropriate fix for all arches mentioned in INPUT_PCSPKR.
> > 
> > For extra points, you can move the duplicate pcspeaker.c code out of all
> > those arches and stash it somewhere in drivers/input. Presumably it's
> > possible to get it to link into the kernel even when INPUT is modular.
> 
> Here's the patch, after spending some time to get familiar with git.
> 
> The patch is against git x86/mm, and it seems to work fine on x86. However,
> on x86, you no longer have /sys/devices/platform/pcspkr after
> running "make allnoconfig". To get it, you have to explicitely add support
> to CONFIG_INPUT_PCSPKR (m or y). I hope this is fine.
> 
> I'm copying the MIPS maintainer as this patch touches his tree too.
> 
> On MIPS, there should be no impact though, as CONFIG_PCSPEAKER is set in
> defconfig files.
>...

The defconfig files do not set anything, they are just .config's you can 
use as a start for configuring your kernel.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

