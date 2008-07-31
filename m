Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYGaNy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYGaNy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYGaNyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:54:16 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55520 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYGaNyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:54:15 -0400
Date: Thu, 31 Jul 2008 16:53:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731135319.GA20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080731093220.969460336@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:27:05AM +0200, Thomas Petazzoni wrote:
> This patch adds the CONFIG_FILE_LOCKING option which allows to remove
> support for advisory locks. With this patch enabled, the flock()
> system call, the F_GETLK, F_SETLK and F_SETLKW operations of fcntl()
> and NFS support are disabled. These features are not necessarly needed
> on embedded systems. It allows to save ~11 Kb of kernel code and data:
> 
>    text	   data	    bss	    dec	    hex	filename
> 1125436	 118764	 212992	1457192	 163c28	vmlinux.old
> 1114299	 118564	 212992	1445855	 160fdf	vmlinux
>  -11137    -200       0  -11337   -2C49 +/-
> 
> This patch has originally been written by Matt Mackall
> <mpm@selenic.com>, and is part of the Linux Tiny project.
>...

As I've already said in the past I'm personally not a huge fan of these 
patches, but if it brings advantages in real-life situations it's hard
to argue against it.

In which use cases can users safely disable this option, and on what 
devices have you verified that CONFIG_FILE_LOCKING=n kernels actually 
work in practice?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

