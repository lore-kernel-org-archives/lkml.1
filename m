Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXC2Rwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXC2Rwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXC2Rwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:52:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37867 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030572AbXC2Rwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:52:54 -0400
Date: Thu, 29 Mar 2007 19:52:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Inlining can be _very_bad...
Message-ID: <20070329175254.GC14134@stusta.de>
References: <20070329011838.6e832615@werewolf-wl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070329011838.6e832615@werewolf-wl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 01:18:38AM +0200, J.A. Magallón wrote:
> Hi all...
> 
> I post this here as it can be of direct interest for kernel development
> (as I recall many discussions about inlining yes or no...).
> 
> Testing other problems, I finally got this this issue: the same short
> and stupid loop lasted from 3 to 5 times more if it was in main() than
> if it was in an out-of-line function. The same (bad thing) happens if
> the function is inlined.
>...
> It looks like is updating the stack on each iteration...This is -march=opteron
> code, the -march=pentium4 is similar. Same behaviour with gcc3 and gcc4.
> 
> tst.c and Makefile attached.
> 
> Nice, isn't it ? Please, probe where is my fault...

The only fault is to post this issue here instead of the gcc Bugzilla.

In your example the compiler should produce code not slower than with 
the out-of-line version when inlining. If it doesn't the bug in the 
compiler resulting in this should be fixed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

