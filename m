Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXCJK7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXCJK7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXCJK7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:59:12 -0500
Received: from holomorphy.com ([66.93.40.71]:38473 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXCJK7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:59:11 -0500
Date: Sat, 10 Mar 2007 02:59:03 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mbligh@google.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
Message-ID: <20070310105903.GA8915@holomorphy.com>
References: <20070310081743.GC23144@Krystal> <20070310082646.GC2994@holomorphy.com> <20070310.002944.115909724.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310.002944.115909724.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007 00:26:46 -0800, William Lee Irwin III <wli@holomorphy.com> wrote:
>> Oh dear. Could we bit a bit more idiomatic here? For instance,
>> something like:

On Sat, Mar 10, 2007 at 12:29:44AM -0800, David Miller wrote:
> Ok I pulled the sparc32 patch back out until there is some
> consensus here :)

It's just a minor touch-up. If Mathieu is okay with it, I'd rather
leave him as the author and just send along an Acked-by: with it.
I'm not terribly attached to it, either. I just choked on my soda
when I saw set_ti_thread_flag(task_thread_info(fpt), TI_USEDFPU)
etc. go by. (Which reminds me, I really need to figure out how to
consolidate the UP and SMP cases for all this.)


-- wli
