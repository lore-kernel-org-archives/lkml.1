Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbXK1UlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbXK1UlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbXK1UlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:41:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45465 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756881AbXK1UlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:41:04 -0500
Date: Wed, 28 Nov 2007 21:40:50 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
Message-ID: <20071128204050.GA29463@stusta.de>
References: <474CA0DA.3010005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474CA0DA.3010005@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:57:30PM -0800, Jeremy Fitzhardinge wrote:
>...
> Christoph Hellwig objects to this patch on the grounds that modules
> shouldn't be using these operations anyway.  I don't think this is a
> particularly good reason to reject the patch, for several reasons:
> 
> 1. These operations are still available to modules when not using
>    CONFIG_PARAVIRT, since they are implicitly exported as inline
>    functions via the kernel headers.  Exporting the same functionality as
>    GPL-only symbols just adds a gratuitious difference between
>    CONFIG_PARAVIRT and non-CONFIG_PARAVIRT configurations.  If we really
>    think these operations are not for module use (or non-GPL module use),
>    then we should solve the problem in a general way.

Current practice in the kernel is that when something that should not be 
done works by chance with some kernel versions and/or configurations 
that's simply an unfortunate fact that should be fixed but doesn't 
result in any guarantee that it works with all kernel versions and/or 
configurations.

> 2. It's a regression from previous kernels, which would work these
>    modules even with CONFIG_PARAVIRT enabled.
>...

It cannot be a regression since the kernel does not have a stable API 
for modules.

> Therefore, I think this patch should go in for 2.6.24.  If people
> really think that these operations should not be available to modules,
> then we can address that separately.
>...

Why should we start with one step back for getting two steps ahead?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

