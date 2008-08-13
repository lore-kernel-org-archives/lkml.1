Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYHMVYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYHMVYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYHMVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:23:59 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37025 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYHMVX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:23:58 -0400
Date: Thu, 14 Aug 2008 00:22:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [2.6.27 patch] #error for gcc 4.1.{0,1}
Message-ID: <20080813212206.GB7071@cs181140183.pp.htv.fi>
References: <20080813204445.GA7071@cs181140183.pp.htv.fi> <20080813135749.b9985fcc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080813135749.b9985fcc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:57:49PM -0700, Andrew Morton wrote:
> On Wed, 13 Aug 2008 23:44:45 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > gcc 4.1.0 and 4.1.1 are known to miscompile the kernel:
> >   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> > 
> > Usage of weak functions has become a common pattern in the kernel, and 
> > usages get added in each kernel version increasing the probability of 
> > bugs with each kernel release.
> > 
> > This miscompilation of weak functions can result in subtle runtime 
> > errors.
> > 
> > #error for gcc 4.1.0 and 4.1.1 to prevent users from running into
> > this bug.
> > 
> > Note:
> > We already printed a #warning for gcc 4.1.0 due to a different bug.
> 
> I've been hiding from this because it would wreck a lot of my
> cross-compilers, which quite a few other people are using as well.

We are talking about runtime breakages, with new breakages added in each 
kernel release.

Which is not nice for users.

And my patch is the result of developers spending time on debugging and 
working around a real-life bug caused by this compiler bug.

If you insist on keeping your 4.1.0 compilers I can prepare a patch that 
removes the fatal __weak usages.

> Vegard, save us!

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

