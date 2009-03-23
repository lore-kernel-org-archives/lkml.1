Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZCWAcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZCWAcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 20:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZCWAcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 20:32:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbZCWAce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 20:32:34 -0400
Date: Sun, 22 Mar 2009 17:23:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] mm: introduce debug_kmap_atomic
Message-Id: <20090322172333.7d7fde92.akpm@linux-foundation.org>
In-Reply-To: <20090314131555.GB17727@elte.hu>
References: <20090311143317.GA22244@localhost.localdomain>
	<tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org>
	<20090314041948.GA3697@localhost.localdomain>
	<20090314131555.GB17727@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009 14:15:55 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > On Fri, Mar 13, 2009 at 01:39:31AM +0000, Ingo Molnar wrote:
> > > x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix
> > > 
> > > Impact: build fix
> > > 
> > > Move kmap_atomic_prot_pfn() to iomap_32.c. It is used on all 32-bit
> > > kernels, while highmem_32.c is only built on highmem kernels.
> > 
> > Thanks for fixing that.
> > 
> > > ( Note: the debug_kmap_atomic_prot() check is removed for now, that
> > >   problem is handled via another patch. )
> > 
> > The patches are now sitting in -mmotm now. For -tip, here are the rebased
> > patches for the debug_kmap_atomic_prot() check.
> 
> Due to the other-arch changes it's better to keep them in -mm i 
> guess. Once the current batch goes out to linux-next (in the 
> next few days) Andrew could pick up the two -tip patches you 
> posted here.

I really don't know what's going on here.
