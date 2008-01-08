Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYAHUbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYAHUbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYAHUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:30:54 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58165 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbYAHUax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:30:53 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4783DE76.7060401@am.sony.com>
Date: Tue, 08 Jan 2008 12:35:02 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Nicholas Mc Guire <mcguire@lzu.edu.cn>
Subject: Re: [RFC PATCH 00/11] mcount tracing utility
References: <20080103071609.478486470@goodmis.org>
In-Reply-To: <20080103071609.478486470@goodmis.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2008 20:30:26.0343 (UTC) FILETIME=[4D48F370:01C85235]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The following patch series brings to vanilla Linux a bit of the RT kernel
> trace facility. This incorporates the "-pg" profiling option of gcc
> that will call the "mcount" function for all functions called in
> the kernel.
> 
> This patch series implements the code for x86 (32 and 64 bit), but
> other archs can easily be implemented as well.

Steven,

This is really exciting!

As a former maintainer of the (out-of-tree) Kernel Function Trace
system, I really welcome this.  I'm just getting out from under
a backlog of work due to the holiday break, but I'm very interested.
I will take a detailed look at this this week.

I have been working with -finstrument-functions for a few years
now, so I know of a few gotchas with that (e.g. It's currently broken
on ARM EABI with GCC 4.x)  This bug is one of the issues that has
prevented me from attempting to mainline the KFT work this last
year.

Please keep me CC'ed on developments in this area, and let me
know if there are any specific things I can do to help.  I'd be
very interested in helping out with non-x86 arch support.

Regards,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

