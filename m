Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZJGHN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZJGHN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZJGHN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:13:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34033
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072AbZJGHN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:13:26 -0400
Date: Wed, 07 Oct 2009 00:13:21 -0700 (PDT)
Message-Id: <20091007.001321.197898334.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, paulus@samba.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091006122359.GA7614@elte.hu>
References: <1254830228.21044.272.camel@laptop>
	<20091006122359.GA7614@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Oct 2009 14:23:59 +0200

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> OK, so I rewrote it a few more times, does the below make everybody 
>> feel warm and fuzzy?
> 
> Yeah, looks perfect to me - applied to tip:perf/urgent, thanks Peter!
> 
> Dave, could you please test it on Sparc too? The Git coordinates are at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/urgent

Works fine here, I forced the vmalloc stuff on using the debug
option.  Once your stuff goes in I'll add the select statement
to arch/sparc/Kconfig

Andrew also needs to marge the vmalloc_user() patch.  I almost
forgot that to apply to my tree when testing :-)
