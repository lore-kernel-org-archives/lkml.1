Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYLLTGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYLLTGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYLLTG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:06:26 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbYLLTGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:06:25 -0500
Message-ID: <4942B62F.1090907@sgi.com>
Date: Fri, 12 Dec 2008 11:06:23 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: fix assign_irq_vector boot up problem
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112806.740820000@polaris-admin.engr.sgi.com> <200812121857.55929.rusty@rustcorp.com.au> <20081212092041.GH25106@elte.hu> <4942A92A.2010306@sgi.com>
In-Reply-To: <4942A92A.2010306@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
...
>> So to do this cleanly, i merged those bits into cpus4096 and the 
>> x86/reboot bits as well - now the plan would be for Mike to send a 
>> (rebased) series against that base. I tried a plain merge and the 
...
> And I've no clue how to cause a git tree to rebase.  What I can do is extract
...

Well I have a clue now (hmm, git-rebase, who would have thunk. ;-)

I'll rebase the for-ingo tree, but I'm still confused about those
files that are in linux-next/rr since they are entering upstream
via linux-next.  Won't any changes I make be dropped when you
push the cpus4096 branch upstream?

Thanks,
Mike
