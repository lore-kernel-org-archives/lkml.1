Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZCTOQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZCTOQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZCTOQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:16:05 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:44189 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752681AbZCTOQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:16:04 -0400
Date: Fri, 20 Mar 2009 10:14:24 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 2.6.27-stable] Fix misreporting of #cores as #hyperthreads for Q9550
Message-ID: <20090320141424.GA27354@tsunami.ccur.com>
References: <20090319172744.GA2600@tsunami.ccur.com> <20090320003233.GC18781@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320003233.GC18781@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 05:32:33PM -0700, Greg KH wrote:
> On Thu, Mar 19, 2009 at 01:27:44PM -0400, Joe Korty wrote:
> > Fix misreporting of #cores for the Intel Quad Core Q9550.
> > 
> > [ for 2.6.27-stable ]
> > 
> > For the Q9550, in x86_64 mode, /proc/cpuinfo mistakenly
> > reports the #cores present as the #hyperthreads present.
> > i386 mode was not examined but is assumed to have the
> > same problem.
> > 
> > A backport of the following three 2.6.29-rc1 patches
> > fixes the problem:
> > 
> >   [PATCH] x86: unmask CPUID levels on Intel CPUs
> >   [PATCH] x86: unmask CPUID levels on Intel CPUs, fix
> >   [PATCH] x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>
> 
> Can you provide the git commit ids for these patches?


066941bd4eeb159307a5d7d795100d0887c00442 [PATCH] x86: unmask CPUID levels on Intel CPUs
99fb4d349db7e7dacb2099c5cc320a9e2d31c1ef [PATCH] x86: unmask CPUID levels on Intel CPUs, fix
bdf21a49bab28f0d9613e8d8724ef9c9168b61b9 [PATCH] x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>
