Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYFSE5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYFSE5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYFSE4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 00:56:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYFSE4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:56:54 -0400
Date: Wed, 18 Jun 2008 21:56:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] agp patches for 2.6.26 final
In-Reply-To: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
Message-ID: <alpine.LFD.1.10.0806182153140.2907@woody.linux-foundation.org>
References: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2008, Dave Airlie wrote:
> 
> commit 62c96b9d0917894c164aa3e474a3ff3bca1554ae
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 19 14:27:53 2008 +1000
> 
>     agp/intel: cleanup some serious whitespace badness
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>

Aarghh!

This one does _not_ just clean up whitespace. It also does

	@@ -1959,8 +1959,6 @@ static const struct agp_bridge_driver intel_i965_driver = {
	 	.size_type		= FIXED_APER_SIZE,
	 	.num_aperture_sizes	= 4,
	 	.needs_scratch_page	= true,
	-	.configure		= intel_i915_configure,
	-	.fetch_size		= intel_i9xx_fetch_size,
	 	.cleanup		= intel_i915_cleanup,
	 	.tlb_flush		= intel_i810_tlbflush,
	 	.mask_memory		= intel_i965_mask_memory,

which may well be all good, but it doesn't match the commit message.

I merged it, but please be more careful.

		Linus
