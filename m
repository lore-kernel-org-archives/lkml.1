Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbYEKWSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbYEKWSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYEKWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:18:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42523 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYEKWSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:18:41 -0400
Date: Mon, 12 May 2008 01:17:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       LAK <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: Remove last reminants of dyntick support
Message-ID: <20080511221719.GO1645@cs181133002.pp.htv.fi>
References: <git-1210542959-a5b32acc9d50dd3c819c2dc5d43bd416f24aa8fd@dyn-67.arm.linux.org.uk> <git-1210542959-a11b6c9b49632402270784b9d516213aad96da7e@dyn-67.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <git-1210542959-a11b6c9b49632402270784b9d516213aad96da7e@dyn-67.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:56:00PM +0100, Russell King wrote:
> From: Russell King <rmk@dyn-67.arm.linux.org.uk>
> 
> Neither S390 nor SH have the configuration option for NO_IDLE_HZ
> in their Kconfig files, yet their defconfig files lists them.
> Remove those references.
>...

I'm not a fan of touching defconfig files this way - this easily leads 
to patch conflicts without any real advantage.

Either a defconfig gets updated and will get this update automatically, 
or it's anyway so full of old stuff that one option more or less doesn't 
make a difference.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

