Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYCGCVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYCGCVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYCGCU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:20:59 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60316 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756834AbYCGCU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:20:58 -0500
Date: Thu, 6 Mar 2008 18:20:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080307020443.GA21185@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061816430.28976@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
 <20080303201701.GF8974@wotan.suse.de> <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
 <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
 <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de>
 <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com>
 <20080306024904.GA27150@wotan.suse.de> <Pine.LNX.4.64.0803061451230.16212@schroedinger.engr.sgi.com>
 <20080307020443.GA21185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Nick Piggin wrote:

> > Do you have a case in mind where that would be useful? We had a 
> 
> Patch 3/3

Those already have SLAB_HWCACHE_ALIGN.

The point is to switch off alignment for UP? Cant we do that with 
SLAB_HWCACHE_ALIGN too since SLOB seemed to work successfully without it 
in the past?

> > Note that there is also KMEM_CACHE which picks up the alignment from 
> > the compiler.
> 
> Yeah, that's not quite as good either. My allocation flag is dynamic, so
> it will not bloat things for no reason on UP machines and SMP kernels. 
> It also aligns to the detected machine cacheline size rather than a
> compile time constant.

Is that really a noteworthy effect?
