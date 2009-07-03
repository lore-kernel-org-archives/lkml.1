Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZGCWSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZGCWSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 18:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZGCWSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 18:18:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:32943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbZGCWSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 18:18:13 -0400
Subject: Re: [PATCH] vt: add an event interface
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 03:47:42 +0530
Message-Id: <1246659462.2511.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 18:42 +0200, Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > A good example of what happens if you don't is
> > 
> > scripts/checkpatch.pl --file arch/x86/kernel/cpu/mtrr/*c
> > 
> > where the core part of the code isn't changed very much even 
> > though the interfaces completely get reworked. Thus it never gets 
> > cleaned up and reviewed as a whole. The code works, will probably 
> > work for years but never gets looked at as a whole and tidied.
> 
> I think even the MTRR code (which is indeed one of the few x86 
> places still not fully cleaned up) supports my arguments.
> 
> Look at the averages:
> 
>                                       errors   lines of code   errors/KLOC
> arch/x86/kernel/cpu/mtrr/amd.c             2             120          16.6
> arch/x86/kernel/cpu/mtrr/centaur.c         8             225          35.5
> arch/x86/kernel/cpu/mtrr/cleanup.c         0            1102             0
> arch/x86/kernel/cpu/mtrr/cyrix.c          10             275          36.3
> arch/x86/kernel/cpu/mtrr/generic.c        16             730          21.9
> arch/x86/kernel/cpu/mtrr/if.c             11             428          25.7
> arch/x86/kernel/cpu/mtrr/main.c           50             751          66.5
> arch/x86/kernel/cpu/mtrr/state.c           0              83             0
> 
> The arch/x86/kernel/cpu/mtrr/cleanup.c file is a new bit and 
> relatively clean.
> 

I will fix these ASAP ;-)

Thanks,
--
JSR

