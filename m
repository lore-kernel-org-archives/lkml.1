Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZKBS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZKBS2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbZKBS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:28:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbZKBS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:28:20 -0500
Date: Mon, 2 Nov 2009 19:28:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
	smp_processor_id() in preemptible [00000000] code: rmmod
Message-ID: <20091102182808.GA8950@elte.hu>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com> <1256805552.7158.22.camel@marge.simson.net> <20091029091411.GE22963@elte.hu> <1256807967.7158.58.camel@marge.simson.net> <1256813310.7574.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256813310.7574.3.camel@marge.simson.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, non-SMP builds broke:

kernel/built-in.o: In function `kthread_bind':
(.text+0x1d328): undefined reference to `sched_kthread_bind'
make: *** [.tmp_vmlinux1] Error 1

	Ingo
