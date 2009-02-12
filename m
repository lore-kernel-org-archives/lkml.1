Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZBLLDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZBLLDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZBLLDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:03:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZBLLDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:03:02 -0500
Date: Thu, 12 Feb 2009 12:02:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pass in pt_regs pointer for syscalls that need it
	(take 2)
Message-ID: <20090212110250.GA23665@elte.hu>
References: <1234277507-4987-3-git-send-email-brgerst@gmail.com> <1234388638-13663-1-git-send-email-brgerst@gmail.com> <49934C01.8000309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49934C01.8000309@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Brian Gerst wrote:
>> Some syscalls need to access the pt_regs structure, either to copy
>> user register state or to modifiy it.  This patch adds stubs to load
>> the address of the pt_regs struct into the %eax register, and changes
>> the syscalls to take the pointer as an argument instead of relying on
>> the assumption that the pt_regs structure overlaps the function
>> arguments.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> Testing this now, together with the do_rt_sigreturn -> sys_rt_sigreturn  
> change.  If it works okay I'll commit it as an incremental diff to  
> tip:core/percpu.

FYI, i merged the delta commit you applied to tip:master as well - it's all
looking good in testing so far.

	Ingo
