Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZIDJ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZIDJ46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933431AbZIDJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:56:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56875
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933374AbZIDJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:56:57 -0400
Date: Fri, 04 Sep 2009 02:57:12 -0700 (PDT)
Message-Id: <20090904.025712.157403360.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090904063419.GO18599@kernel.dk>
References: <20090903.220906.44384937.davem@davemloft.net>
	<20090904052005.GN18599@kernel.dk>
	<20090904063419.GO18599@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 4 Sep 2009 08:34:19 +0200

> It seems I had a left-over arch/sparc/include/asm/perf_counter.h from
> earlier experiments that was never checked in, so that is why it worked
> for me. include/linux/sched.h does:

That explains everything :-)

>     sparc: add basic support for 'perf'
>     
>     This wires up the perf_counter_open() syscall so that basic
>     software support for perf is working.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Applied to sparc-next-2.6, thanks!

As time allows I'll work on hw counter support.
