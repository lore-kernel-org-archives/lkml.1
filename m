Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0BVJH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:07:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0BVJHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:07:25 -0500
Date: Mon, 22 Feb 2010 10:07:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/ptrace] ptrace: Add support for generic
 PTRACE_GETREGSET/PTRACE_SETREGSET
Message-ID: <20100222090710.GA31357@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Commit-ID:  2225a122ae26d542bdce523d9d87a4a7ba10e07b
> Gitweb:     http://git.kernel.org/tip/2225a122ae26d542bdce523d9d87a4a7ba10e07b
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Thu, 11 Feb 2010 11:51:00 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 11 Feb 2010 15:08:33 -0800
> 
> ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET

FYI, this commit broke tip:master on PARISC (other architectures are fine):

 kernel/built-in.o: In function `ptrace_request':
 (.text.ptrace_request+0x2cc): undefined reference to `task_user_regset_view'

I'll keep them in tip:master to get them tested, but note that i cannot push 
any of these patches into linux-next until this is fixed, as linux-next 
requires all architectures to build, with no regard to which architectures are 
tested by kernel testers in practice.

	Ingo
