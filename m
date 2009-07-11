Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZGKLut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZGKLut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZGKLum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:50:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4111 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZGKLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:50:42 -0400
Date: Sat, 11 Jul 2009 13:50:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -tip: block, fuse: Fix build error in fs/fuse/dev.c
Message-ID: <20090711135000.0ef4fa3e@hyperion.delvare>
In-Reply-To: <20090711111040.GA20431@elte.hu>
References: <20090711075201.GA6517@elte.hu>
	<20090711124326.792f3177@hyperion.delvare>
	<20090711111040.GA20431@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 13:10:40 +0200, Ingo Molnar wrote:
> 
> * Jean Delvare <khali@linux-fr.org> wrote:
> > I have hit this build issue as well, but with CONFIG_BLOCK=y, so 
> > the patch above does NOT fix it. The problem I see is that 
> > fs/fuse/dev.c does not include <linux/blkdev.h> so it doesn't get 
> > the definitions regardless of the configuration. Same problem in 
> > fs/nfs/write.c. The patch below fixes it for me:
> 
> Yes, that's a different build bug already fixed in latest upstream:
> 
>  097041e: fuse: Fix build error

Ah, I had missed that one because it has not been snapshot yet. Thanks
for pointing it out.

-- 
Jean Delvare
