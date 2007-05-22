Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbXEVXRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbXEVXRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbXEVXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:17:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42439 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756655AbXEVXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:17:35 -0400
Date: Wed, 23 May 2007 01:17:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Maneesh Soni <maneesh@in.ibm.com>,
       stable@kernel.org
Subject: Re: [stable] [PATCH] - fix oops in sysfs_readdir
Message-ID: <20070522231722.GD2098@stusta.de>
References: <4651E0C9.3080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4651E0C9.3080609@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 01:11:21PM -0500, Eric Sandeen wrote:
> This is a non-ida backport of Tejun's patch in -mm at:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> for the 2.6.16 -stable tree - it follows the same scheme of using s_ino to safely
> store & retrieve the inode number of sysfs entries for use in sysfs_readdir,
> but uses a brain-dead-simple inode nr allocator rather than ida, which would
> bring along a lot of newer, more complex code.
> 
> No, this doesn't guarantee uniqueness of sysfs inode numbers, but then
> the code in -stable today doesn't either - and with this change, at least
> it shouldn't oops.
> 
> Comments?

First of all, thanks for any contributions to 2.6.16.

My biggest problem with this patch is:
It's not yet fixed in Linus' tree - and if it isn't important enough for 
being fixed in 2.6.22, it can't be important enough for 2.6.16.

And no matter whether this might include adding ida to 2.6.16, I'd 
prefer to apply something as near as possible to whatever gets
into 2.6.22.

> Thanks,
> 
> -Eric
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

