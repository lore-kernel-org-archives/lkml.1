Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYGOVCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYGOVCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbYGOVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:02:38 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41447 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871AbYGOVCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:02:36 -0400
Date: Wed, 16 Jul 2008 00:02:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] chsc headers userspace cleanup
Message-ID: <20080715210230.GK24533@cs181140183.pp.htv.fi>
References: <20080715125817.GB24533@cs181140183.pp.htv.fi> <20080715191748.1f3905ad@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080715191748.1f3905ad@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:17:48PM +0200, Cornelia Huck wrote:
> On Tue, 15 Jul 2008 15:58:18 +0300,
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Kernel headers shouldn't expose functions to userspace.
> 
> Could you please elaborate? Especially as I see e.g.
> include/linux/virtio_ring.h exporting functions outside #ifdef
> __KERNEL__ as well...

Our headers are in a bad shape...

The userspace headers should contain everything that is part of the ABI 
between the kernel and userspace.

Nothing more.

The kernel is heavily changing with each release while the userspace ABI 
is cast in stone, and leaking more stuff to userspace than required only 
increases the chances of some userspace programmer using it and some 
kernel programmer then changing it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

