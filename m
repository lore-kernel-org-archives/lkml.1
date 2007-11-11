Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXKKFKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXKKFKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 00:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXKKFKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 00:10:12 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48187 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbXKKFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 00:10:10 -0500
Date: Sun, 11 Nov 2007 06:09:45 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility
	ARCH={i386,x86_64} for x86
Message-ID: <20071111050945.GB21669@stusta.de>
References: <20071110204038.GA13140@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071110204038.GA13140@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 09:40:38PM +0100, Sam Ravnborg wrote:

> As discussed in another thread the right thing is to add a generic solution
> to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.
>...

I seriously question this would be "the right thing".

32/64bit isn't that special that this and only this option would require
special casing, and the KISS principle of having only one way to specify 
something like this has it's advantages.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

