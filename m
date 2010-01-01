Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022Ab0AAPtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0AAPtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916Ab0AAPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:49:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54082 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0AAPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:49:31 -0500
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stefani Seibold <stefani@seibold.net>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: revert to show stack information in /proc/{pid}/status
From: Andi Kleen <andi@firstfloor.org>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	<1262274494.14143.7.camel@wall-e>
	<20100101155630.1A1E.A69D9226@jp.fujitsu.com>
Date: Fri, 01 Jan 2010 16:49:29 +0100
In-Reply-To: <20100101155630.1A1E.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's message of "Fri, 1 Jan 2010 23:14:23 +0900 (JST)")
Message-ID: <87pr5t7rli.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>
> Anyway, I revert the regresstion patch as other regression patches. if you really want
> this feature, you have three options.
>
>   1. create new /proc file instead to use /proc/pid/status.
>   2. improve performance until typical use-case don't notice regression.
>   3. change ps and other /proc related userland implementation and resubmit this patch.
>
> But even if you choose anything, You have to test both its functional and performance
> _before_ submitting kernel patch.


4. Leave everything alone (revert all the commits) and use a ptrace
based tool to get this information when you need it.

That is what I suggested during the original code review and I still think
it's the best solution for such a obscure problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
