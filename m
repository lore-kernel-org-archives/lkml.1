Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbXE3XVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbXE3XVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXE3XVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:21:03 -0400
Received: from holomorphy.com ([66.93.40.71]:39261 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXE3XVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:21:01 -0400
Date: Wed, 30 May 2007 16:21:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GFP_DMA32 and PAE x86 machines
Message-ID: <20070530232101.GG6909@holomorphy.com>
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com> <465DECD7.8030104@zytor.com> <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com> <200705310024.25937.ak@suse.de> <21d7e9970705301609w88a9f80t20f83806003f699e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970705301609w88a9f80t20f83806003f699e@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Andi Kleen <ak@suse.de> wrote:
>> Please give a very very strong rationale why you want it. Did you actually
>> run into such a situation yourself yet?

On Thu, May 31, 2007 at 09:09:58AM +1000, Dave Airlie wrote:
> Funnily enough I have just today with an app I have which uses 1.2GB
> of textures :-)
> we are currently using GFP_DMA32 in the TTM allocator code, however
> what I really want on x86 non-PAE is GFP_HIGHMEM (as DMA32 does
> nothing) however on x86-PAE I don't want that I want a real GFP_DMA32,
> and on x86-64 I want the current GFP_DMA32,
> Therein lies my problems, the API sucks, but I suppose the DRM TTM is
> a special use case (AGP is the same) and I'll accept the fact that can
> just make it my own problem, my current solution would be to screw PAE
> machines giving them 1GB only and let non-PAE access all 4GB.

It's easy enough to spin kernels that allow 4GB-constrained highmem
allocations. The real question is whether it'll be merged.


-- wli
