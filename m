Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZHFD0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZHFD0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZHFD0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:26:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6073 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZHFD0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:26:16 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz62a3L1432R98dN936eM4015Lzz1202hzzz32i6bh21ch203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNXQV6-04-4P9-01
Date: Thu, 6 Aug 2009 05:26:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] perfcounter fixes
Message-ID: <20090806032603.GD25478@erda.amd.com>
References: <20090804191832.GA2020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090804191832.GA2020@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 03:26:05.0341 (UTC) FILETIME=[A19C4CD0:01CA1645]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.09 21:18:32, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest perfcounters-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus
> 
> Note, i was unsure about this commit:
> 
>   f265426: perf_counter: Set the CONFIG_PERF_COUNTERS default to y if CONFIG_PROFILING=y
> 
> Is it proper to offer up a default-y if CONFIG_PROFILING is set to y 
> already and default-off otherwise?
> 
> I kept this the last commit so we can zap it easily if it's not ok.
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Arnaldo Carvalho de Melo (1):
>       perf top: Add mwait_idle_with_hints to skip_symbols[]
> 
> Ingo Molnar (2):
>       perf_counter tools: Fix link errors with older toolchains
>       perf_counter: Set the CONFIG_PERF_COUNTERS default to y if CONFIG_PROFILING=y

Setting CONFIG_PERF_COUNTERS=y per default for -rc6? Wouldn't this be
something for the next merge window? Give people the chance to test
this, changing default configurations shouln't be made this late in
the release cycle.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

