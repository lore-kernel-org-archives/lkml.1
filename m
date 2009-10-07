Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZJGVMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZJGVMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZJGVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:12:53 -0400
Received: from www.tglx.de ([62.245.132.106]:44073 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZJGVMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:12:52 -0400
Date: Wed, 7 Oct 2009 23:01:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
In-Reply-To: <20091007201338.GE5903@nowhere>
Message-ID: <alpine.LFD.2.00.0910072259230.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain> <20091007201338.GE5903@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Frederic Weisbecker wrote:
> Hmm, I'm discovering that in tip:rt/kill-the-bkl
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=55968ede164ae523692f00717f50cd926f1382a0
> 
> Looks like we have overlaped.
> 
> Thomas it would be nice to post these patches on LKML (or I missed
> them?) and may be to merge them into tip:master, so that they are
> visible and then we lower the risk of any duplicate works in this area.

Now guess why I mentioned this branch sevaral times at the rt summit
last week. It's even documented in Jonathans excellent meeting
minutes on lwn.net :)

Thanks,

	tglx
