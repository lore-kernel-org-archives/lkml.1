Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYKKDhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYKKDhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYKKDha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:37:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbYKKDha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:37:30 -0500
Date: Mon, 10 Nov 2008 19:37:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.28-rc4-mmotm1110 - you gotta be kidding me...
Message-Id: <20081110193713.d94ed39a.akpm@linux-foundation.org>
In-Reply-To: <30622.1226372137@turing-police.cc.vt.edu>
References: <30622.1226372137@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 21:55:37 -0500 Valdis.Kletnieks@vt.edu wrote:

> Somebody's been hitting the phunky pharmaceuticals in the last 4 days,
> because this ball-of-joy snuck into linux-next.patch sometime between
> -mmotm1106 and --mmotm1110.
> 
> Seen in a 'make silentallconfig'
> 
>   Single-depth WCHAN output (SCHED_NO_NO_OMIT_FRAME_POINTER) [Y/n/?] (NEW) ?
> 
>   Calculate simpler /proc/<PID>/wchan values. If this option
>   is disabled then wchan values will recurse back to the
>   caller function. This provides more accurate wchan values,
>   at the expense of slightly more scheduling overhead.

I got lost here.

>   If in doubt, say "Y".
> 
> So if I say 'y', is that a request to disable it, or enable it?  And
> what exactly do I get if I vote *against* 'more accurate wchan values'?
> Do I get everybody having the same wchan pointing somewhere in the
> scheduler code, because that's where __builtin_return_address() points?
> 
> And please - a triple negative in the Kconfig variable name?  This has
> gotta be a winner for poor taste in variable naming...
> 

Even if that is all sorted out, how the heck is anyone to decide
whether or not they need this thing?

Also, if we really really are so wishy-washy indecisive that we need to
make the function optional, it should if at all possible be made
runtime-configurable, not compile-time.

