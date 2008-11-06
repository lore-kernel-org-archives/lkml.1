Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYKFWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYKFWdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYKFWdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:33:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKFWdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:33:37 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
From: Andi Kleen <andi@firstfloor.org>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
	<20081106061125.GA6384@elte.hu>
	<b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
	<20081106063012.GA15731@elte.hu>
Date: Thu, 06 Nov 2008 23:33:42 +0100
In-Reply-To: <20081106063012.GA15731@elte.hu> (Ingo Molnar's message of "Thu, 6 Nov 2008 07:30:12 +0100")
Message-ID: <87mygco56h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> are you interested in adding /proc/<PID>/stacktrace? If yes then we 
> could remove fp generation for 64-bit right now and add your 
> stacktrace patch when you are done with it.

FWIW there used to be a patch floating around doing that a couple of
years ago and even used in some distros. But the big problem was if
someone read all of proc it took a lot of CPU time to do all the stack
tracing. This also was triggerable from non root.

So yes it's useful, but it can be costly.

-Andi

-- 
ak@linux.intel.com
