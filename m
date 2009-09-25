Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZIYWvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZIYWvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZIYWvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:51:32 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:57337 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbZIYWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:51:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Aneurin Price <aneurin.price@gmail.com>
Subject: Re: Regression: kernels since 2.6.26 are unusably slow
Date: Sat, 26 Sep 2009 00:51:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai.lu@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
In-reply-To: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909260051.34541.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2009 22:51:35.0142 (UTC) FILETIME=[BBACA060:01CA3E32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding maintainers involved with the commit in CC.

Aneurin Price wrote:
> Hi,
> Every kernel since 2.6.26 has been unusably slow for me - to the extent
> that I initially thought they were hanging on boot. Exactly how bad it is
> seems to vary, but it could take several minutes to boot, and then
> another minute or two to log in (with bash pegging the CPU as it loads).
> Everything seems to need vastly more CPU time than usual - it feels a
> little like I'm using a 486.
> 
> I've bisected the problem down to commit
> 42651f15824d003e8357693ab72c4dbb3e280836 (x86: fix trimming e820 with
> MTRR holes). Having basically no idea what that means, I thought I'd try
> building a kernel with MTRRs disabled, to see if that would make any
> difference, but no joy.
> 
> Can anyone give me some idea of where to go next, or let me know what
> further information I should provide?

Let's start with some basic info. Can you please send your kernel config 
and the output of 'dmesg' after a boot with a "slow" kernel?

Also, what distribution do you use (and what is its release/version)?

Cheers,
FJP
