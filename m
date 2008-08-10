Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYHJXWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYHJXWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 19:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHJXVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 19:21:55 -0400
Received: from ozlabs.org ([203.10.76.45]:58359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYHJXVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 19:21:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18591.30474.127939.243247@cargo.ozlabs.ibm.com>
Date: Mon, 11 Aug 2008 09:17:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       benh@kernel.crashing.org
Subject: Re: please pull cell merge branch
In-Reply-To: <200808091513.05251.arnd@arndb.de>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	<200808081526.21405.arnd@arndb.de>
	<1218235184.6637.111.camel@carll-linux-desktop>
	<200808091513.05251.arnd@arndb.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann writes:

> I've fixed one last bug in Carl's update for cell-oprofile (int flags
> instead of unsigned long flags) and made sure the comments fit the
> usual style. This fixes a long-standing bug that prevented us from
> using oprofile on SPUs in many real-world scenarios. Please
> pull from
> 
>  master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge
> 
> so we can get it fixed in 2.6.27-rc3. Sorry for the size of the patch
> so late after the merge window, unfortunately it wasn't possible to
> fix the problem in a simpler way.
> 
> 	Arnd <><
> 
> ---
> 
>  arch/powerpc/oprofile/cell/pr_util.h       |   13 +
>  arch/powerpc/oprofile/cell/spu_profiler.c  |    4
>  arch/powerpc/oprofile/cell/spu_task_sync.c |  236 ++++++++++++++++++++++++---
>  drivers/oprofile/buffer_sync.c             |   24 ++
>  drivers/oprofile/cpu_buffer.c              |   15 +
>  drivers/oprofile/event_buffer.c            |    2
>  drivers/oprofile/event_buffer.h            |    7
>  include/linux/oprofile.h                   |   16 +
>  drivers/oprofile/cpu_buffer.c              |    4

Since you're touching generic oprofile code here, do you have an ack
from the oprofile maintainer?  Or is the oprofile maintainer listed in
MAINTAINERS (Robert Richter) no longer active or something?

Paul.
