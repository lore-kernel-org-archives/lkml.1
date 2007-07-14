Return-Path: <linux-kernel-owner+w=401wt.eu-S965018AbXGNBjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbXGNBjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937636AbXGNBh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:37:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60687 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937607AbXGNBhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:37:24 -0400
Date: Sat, 14 Jul 2007 03:36:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Use --build-id ld option
Message-ID: <20070714013658.GD3565@stusta.de>
References: <4695B28E.2020603@goop.org> <20070712062458.6B2BD4D0489@magilla.localdomain> <20070714012301.GB3565@stusta.de> <4698264B.7080406@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4698264B.7080406@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 06:26:35PM -0700, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>> But note that twice compiling a kernel with the same .config will result 
>> in a different one.
>
> Is that true even if you reset the .version counter each time?  I'm 
> thinking of product build systems, in which they value being able to 
> reproduce the same build (ideally, bit for bit).

$ grep UTS_VERSION include/linux/compile.h
#define UTS_VERSION "#3 Sat Jul 14 03:21:18 CEST 2007"
$ 

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

