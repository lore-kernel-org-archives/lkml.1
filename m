Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811Ab0ATWq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0ATWq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781Ab0ATWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:46:56 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:45880 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758Ab0ATWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:46:55 -0500
Date: Thu, 21 Jan 2010 09:46:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: Obsolete config in kernel build system (XFS_TRACE)
Message-ID: <20100120224626.GP14035@discord.disaster>
References: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 01:52:49PM +0100, Christoph Egger wrote:
> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
>
> 	Git commit 0b1b213fcf3a8486ada99a2bab84ab8c6f51b264 by
> Christoph Hellwig removed all References to CONFIG_XFS_TRACE, which is
> unreferenced from KConfig side from the linux source code so there's
> only a small bit of it left in KBuild. Mayee remove it as well?
> 
> ./fs/xfs/Makefile:95
> +++>
> 
> xfs-$(CONFIG_XFS_TRACE)         += xfs_btree_trace.o
> 
> <+++
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

Christoph's conversion to use the kernel trace infrastructure is
a work in progress. It's no small task - he's converted around 220
trace points points so far.

However, the btree tracing code has not been converted yet. IIRC
this is because the kernel trace code didn't have the required
infrastructure at the time of initial conversion. Hence the old code
has not yet been completely removed because the conversion is not
yet complete.  It will go away when the conversion is completed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
