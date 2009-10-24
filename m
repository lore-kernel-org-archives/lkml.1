Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbZJXAbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbZJXAbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 20:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZJXAbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 20:31:13 -0400
Received: from icculus.org ([67.106.77.212]:45987 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZJXAbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 20:31:13 -0400
Date: Fri, 23 Oct 2009 20:31:16 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel
 modules.
In-Reply-To: <4AE22D04.50708@goop.org>
Message-ID: <alpine.OSX.1.10.0910232026080.2186@caridad.icculuslan>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan> <4ADD0086.9060304@goop.org> <alpine.DEB.2.00.0910200043200.18342@andre.icculuslan> <4AE22D04.50708@goop.org>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Oct 2009, Jeremy Fitzhardinge wrote:

> Any open source driver should be encouraged to be merged with mainline
> Linux so there's no need to distribute them separately.  With the
> staging/ tree, that's easier than ever.

Yes, absolutely. I agree.

But even for mainline drivers, there's a compelling use-case for this, 
even for a Linux distribution that's 100% Free Software.

Those that want to play outside the sandbox still have all the misery of 
having to keep up with kernel interface changes and supporting multiple 
kernel releases. That's the hard part for them, and I'm happy to continue 
to make it uncomfortable in that regard. How the kernel module gets loaded 
is probably not of great importance compared to the engineering resources 
they probably devote to just keeping up.

> Well, ideally a fat module would allow modules for multiple kernels to
> be bundled together (same and/or different architectures), which is
> primarily useful for 3rd-party binary distributions.

If the OSABI version doesn't change, they can't use FatELF to pack 
together multiple drivers for different kernel versions. fatelf-glue 
refuses to merge them, and the kernel will pick the first one, and if it 
fails to load, tough luck.

I think this should resolve the concern from a technical standpoint. They 
still have the same problems.

--ryan.

