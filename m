Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXE1RBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXE1RBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbXE1RBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:01:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47208 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbXE1RBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:01:14 -0400
Date: Mon, 28 May 2007 19:01:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Nitin Gupta <nitingupta910@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070528170109.GP3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <20070528153055.GN3899@stusta.de> <4cefeab80705280847q62d68ebavd74c5a9d425de0f6@mail.gmail.com> <200705281155.14466.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200705281155.14466.dhazelton@enter.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 11:55:14AM -0400, Daniel Hazelton wrote:
>...
> This is my guess as well. Though performance will likely drop when I make the 
> noinline macro mean something. (This may be offset by figuring out a way to 
> make likely() and unlikely() also have a meaningful effect in userspace).
>...

What is your problem?

The likely/unlikely macros aren't in any way depending on any kernel 
infrastructure.

> DRH

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

