Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXJaQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXJaQBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXJaQBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:01:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42008 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbXJaQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:01:43 -0400
Date: Wed, 31 Oct 2007 17:01:42 +0100
From: Jan Kara <jack@suse.cz>
To: Ram <vshrirama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel processes - are they really needed?
Message-ID: <20071031160142.GC28809@atrey.karlin.mff.cuni.cz>
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>     When i do ps -l. i see the following processes which are obviously
> started by kernel.
> 
>    Could any one tell me what each of these processes do and can
> anyone of them can be removed.?
  I'll write what I know :)

> PID  Uid     VmSize Stat Command
>     1 root        584 S   init
>     2 root            SWN [ksoftirqd/0]
>     3 root            SW  [watchdog/0]
>     4 root            SW< [events/0]
>     5 root            SW< [khelper]
>     6 root            SW< [kthread]
>    23 root            SW< [kblockd/0]
  This one has something to do with block layer - like unplugging
request queue after a certain timeout etc.

>    38 root            SW  [pdflush]
>    39 root            SW  [pdflush]
  Doing writeback of dirty data.

>    40 root            SW< [kswapd0]
  Swapping pages in and out.

>    41 root            SW< [aio/0]
  Kernel thread handling asynchronous IO.

>    85 root            SW  [mtdblockd]
>   116 root            SWN [jffs2_gcd_mtd9]
  jffs2 specific - ask a maintainer :) (and mtdblockd has something to
do with MTD devices so he may know that one as well).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
