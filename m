Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZADXMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZADXMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZADXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:12:09 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:60770 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZADXMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:12:08 -0500
Message-ID: <49614243.70102@knaff.lu>
Date: Mon, 05 Jan 2009 00:12:03 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: update8 [PATCH 2/5] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com>
In-Reply-To: <4961415C.1050708@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi Alain,
> 
> Looking pretty good now.  The only issues that I see so far are:
> 
> - Putting the kernel compression selection in init/Kconfig isn't going
>   to work too well, since it affects all architectures, and not all
>   architectures even do their own decompression (for quite a few
>   architectures it's the boot loader's responsibility.)
> 
>   I see two options here: either have this be parameterized by the arch
>   Kconfig files, or simply move this chunk into arch/*/Kconfig as part
>   of the arch-enablement patches.  The latter is probably the simplest,
>   even if it means some replicated code.
> 
>   Let me know what you think

What do you mean "parametrized by the arch Kconfig files"? Does this
mean that it would still be in the global files, but would be enabled by
some kind of switch or preprocessor macro in the arch dependant file? If
easily doable, this would IMHO be preferable.

However, if not easily feasible, I'm also ok with duplication.

> -- I can do this pretty easily while
>   importing, so you don't need to submit a full new patchset.

Thanks, that would be nice.

> - I did a followon patch (attached) to change the ramdisk compression
>   search to table driven.  Since I already did the followon patch, don't
>   worry about it.
> 
> 	-hpa
> 
> 

Ok

Thanks,

Alain
