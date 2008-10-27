Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbYJ0QEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbYJ0QEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYJ0QD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:03:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYJ0QD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:03:58 -0400
Date: Mon, 27 Oct 2008 17:03:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in
	tracing/iter_ctrl
Message-ID: <20081027160348.GT5704@elte.hu>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0020]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Usage example:
> mount -t debugfs nodev /sys/kernel/debug
> cd /sys/kernel/debug/tracing
> echo userstacktrace >iter_ctrl
> echo sched_switch >current_tracer
> echo 1 >tracing_enabled
> .... run application ...
> echo 0 >tracing_enabled
> 
> Then read one of 'trace','latency_trace','trace_pipe'

okay, this makes quite a bit of sense - and sysprof already kind of 
walks down into the user-space stack. (and so does oprofile, if asked)

Could you send this independently of the lock contention tracing 
patches perhaps?

	Ingo
