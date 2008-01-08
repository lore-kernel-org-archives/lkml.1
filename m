Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYAHW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYAHW44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYAHW4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:56:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYAHW4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:56:46 -0500
Date: Tue, 8 Jan 2008 23:56:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: m.kozlowski@tuxland.pl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at
	kernel/lockdep_proc.c:267 lockdep_stats_show()
Message-ID: <20080108225631.GA7021@elte.hu>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801081942.17139.m.kozlowski@tuxland.pl> <20080108.145038.203528847.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108.145038.203528847.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> > WARNING: at kernel/lockdep_proc.c:267 lockdep_stats_show()
> > Call Trace:
> >  [0000000000492704] lockdep_stats_show+0x6ac/0x6c0
> >  [00000000004eb4b4] seq_read+0x5c/0x340
> >  [000000000050b2bc] proc_reg_read+0x64/0xa0
> >  [00000000004cd72c] vfs_read+0x74/0x120
> >  [00000000004cdb4c] sys_read+0x34/0x60
> >  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
> >  [0000000000012ff4] 0x12ffc
> 
> Please turn off lockdep on sparc64, currently it not reliable.  I have 
> many things to audit, including how the stack frames are presented to 
> the lockdep layer.
> 
> So any problem you run into can be due to issues like that.

is this anything the core lockdep code could help improve? Let us know 
if any aspect is hindering you.

	Ingo
