Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXC0UQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXC0UQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXC0UQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:16:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41304 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXC0UQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:16:09 -0400
Date: Tue, 27 Mar 2007 13:12:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: 2.6.21-rc5-mm1
Message-Id: <20070327131214.656e1ad7.akpm@linux-foundation.org>
In-Reply-To: <1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	<1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com>
	<20070327084838.34dc1b84.akpm@linux-foundation.org>
	<1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 09:57:50 -0800
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Tue, 2007-03-27 at 08:48 -0800, Andrew Morton wrote:
> > On Tue, 27 Mar 2007 09:39:33 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:
> > 
> > > On Mon, 2007-03-26 at 20:57 -0800, Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/
> > > > 
> > > 
> > > 
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > ld: section .vsyscall_1 [0000000000645400 -> 000000000064542e] overlaps
> > > section .jiffies [0000000000645400 -> 0000000000645407]
> > > ld: .tmp_vmlinux1: section .vsyscall_1 lma 0x645400 overlaps previous
> > > sections
> > > make: *** [.tmp_vmlinux1] Error 1
> > > 
> > 
> > bah.  Please send .config.
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.21-rc5-mm1

The wheel spins around, slows then settles on.... 
time-smp-friendly-alignment-of-struct-clocksource.patch!

Presumably because the ____cacheline_aligned made vsyscall_gtod_data_t get
too big.  Or something.

