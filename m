Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZHLSNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZHLSNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZHLSNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:13:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43796 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbZHLSNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:13:04 -0400
Date: Wed, 12 Aug 2009 20:13:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090812181305.GQ12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk> <20090802.131705.81498579.davem@davemloft.net> <20090806070242.GF12579@kernel.dk> <20090812.110646.239052896.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812.110646.239052896.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12 2009, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 6 Aug 2009 09:02:42 +0200
> 
> > On Sun, Aug 02 2009, David Miller wrote:
> >> From: Jens Axboe <jens.axboe@oracle.com>
> >> Date: Wed, 29 Jul 2009 13:25:10 +0200
> >> 
> >> > -#define NR_SYSCALLS		327
> >> > +#define NR_SYSCALLS		328
> >> 
> >> When you increase this value, you have to add entries to all of the
> >> syscall tables.  The syscall dispatch checks against this as a limit,
> >> so if you don't explicitly add an entry to all the tables, it's
> >> possible to deref garbage past the end of the table and try to jump to
> >> it as a syscall.
> > 
> > Oops, missed the 32-bit table. Does the below look better?
> 
> I'll take a look at this as soon as I can Jens, sorry for taking
> so long.

No problem, I figured you'd get to it eventually and in the mean time
I'll just keep patching it in.

-- 
Jens Axboe

