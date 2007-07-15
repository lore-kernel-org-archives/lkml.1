Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbXGOXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbXGOXGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXGOXGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:06:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34147 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754488AbXGOXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:06:05 -0400
Date: Mon, 16 Jul 2007 01:05:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070715230524.GL3565@stusta.de>
References: <469A8AED.7070207@nerdgrounds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <469A8AED.7070207@nerdgrounds.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 02:00:29PM -0700, Jonathan Campbell wrote:
> I wrote a set of patches out of concern that even if you compile a 386 
> kernel a lot of code irrelevent to legacy machines still remains. Things 
> like the Pentium TSC register, DMI information, ESCD parsing, and the use 
> of CPUID do not apply to these machines, but looking at System.map you can 
> see they're still there.
>
> Already with these patches I can compile a zImage kernel that is 450kb 
> large (890kb decompressed) with a small initramfs payload, floppy and 
> kernel module support, FPU emulation, that can successfully boot on an 
> ancient 386 laptop with only 1MB of extended memory. Eventually what I'd 
> like to have is the ability to compile a pure 386 kernel with all non-386 
> functions removed (and perhaps the same for 486 machines).
>...

Besides some issues with the patch itself you didn't provide the one 
important number:
By how much does your patch decrease the size of the kernel?

Also note that when aiming for a tiny kernel enabling module support is 
a huge mistake since it increases the amount of RAM used when running 
the kernel by at about 10%.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

