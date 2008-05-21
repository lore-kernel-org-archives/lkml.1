Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYEUHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYEUHy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYEUHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:54:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59124 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbYEUHyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:54:47 -0400
Date: Wed, 21 May 2008 10:52:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: -ffreestanding or not -ffreestanding
Message-ID: <20080521075233.GA18352@cs181133002.pp.htv.fi>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 02:12:07AM +0100, Al Viro wrote:
> Content-Length: 788
> Lines: 30
> 
> Whether we sidestep it in init/main.c or not, such situations
> will arise again; compiler does generate calls of strcat()
> on optimizations, so we really ought to have an out-of-line
> version...
>...

Can we try to get this sorted out properly instead of constantly 
fiddling with it?

Currently we use -ffreestanding on some architectures and fix breakages 
on the other architectures when they arise.

The options I see for getting this fixed properly are:
- use -ffreestanding on all architectures or
- don't use -ffreestanding on any architecture and move the string
  functions (and perhaps other functions if required) out-of-line

I'd prefer the first option, but I know that not everyone agrees with me.

No matter which option we choose, if we get an agreement on this one
I can send patches for it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

