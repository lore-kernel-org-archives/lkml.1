Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYAEJqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYAEJqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYAEJqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:46:47 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44841 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYAEJqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:46:46 -0500
Date: Sat, 5 Jan 2008 11:46:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [2.6.25 patch] remove a.out interpreter for ELF executables
Message-ID: <20080105094618.GA2304@does.not.exist>
References: <20080101134749.GJ2360@does.not.exist> <200801011536.32598.ak@suse.de> <20080105013053.b46cd28b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080105013053.b46cd28b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:30:53AM -0800, Andrew Morton wrote:
> On Tue, 1 Jan 2008 15:36:32 +0100 Andi Kleen <ak@suse.de> wrote:
> 
> > On Tuesday 01 January 2008 14:47:49 Adrian Bunk wrote:
> > > This patch contains the scheduled removal of the a.out interpreter 
> > > support for ELF executables.
> > 
> > I already have a similar patch queued
> > 
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-aout-interpreter
> > 
> > Also removal of the old unused iBCS hooks while I was on it
> > 
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-ibcs-support
> > 
> 
> Guys, please take a look at similar patches from David in -mm before even
> vaguely thinking of breathing anywhere in the remote vicinity of
> fs/binfmt_elf.c (sob).

What David's patch does in fs/binfmt_elf.c is to make code conditional - 
exactly the code Andi removes as scheduled in 2.6.25. You should be able 
to simply drop the fs/binfmt_elf.c parts from
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch.

cu
Adrian

BTW: There are also patch conflicts with git-x86, but since they are not 
     from David you have yet to ask us to look at them.  ;-)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

