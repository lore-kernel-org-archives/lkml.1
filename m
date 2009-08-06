Return-Path: <linux-kernel-owner+w=401wt.eu-S1751035AbZHFELl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbZHFELl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZHFELk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:11:40 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34458 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZHFELk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:11:40 -0400
X-SpamScore: -38
X-BigFish: VPS-38(z21eWz62a3L1432R98dN936eM4015L2f55kzz1202hzzz32i21ch6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNXSYU-03-6VG-01
Date: Thu, 6 Aug 2009 06:11:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL][2.6.31] ring-buffer/tracing: various
	fixes
Message-ID: <20090806041127.GE25478@erda.amd.com>
References: <20090806025206.306150861@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090806025206.306150861@goodmis.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 04:11:29.0559 (UTC) FILETIME=[F95EFA70:01CA164B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.09 22:52:06, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent

Steven,

if there is the chance I would like to see this fix in -rc6 too (I
know you wanted to test it):

 193df82 ring-buffer: Fix advance of reader in rb_buffer_peek()

You can cherry-pick from my oprofile/master tree or linux-next. The
bug throws warnings with oprofile under high loads and I already got
bug reports of this.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

