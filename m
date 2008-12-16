Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbYLPJGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYLPJGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYLPJFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:05:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:58862 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751158AbYLPJFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:05:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cfiY5HAmc0hL1Oi9I6u/Wzl2Pc1D4sia0zND22R
	QBPOEy1tdxGUev
Subject: Re: [PATCH 3/3] sched: prefer wakers
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081216074636.176935879@chello.nl>
References: <20081216074529.570706654@chello.nl>
	 <20081216074636.176935879@chello.nl>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 10:05:43 +0100
Message-Id: <1229418343.7438.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 08:45 +0100, Peter Zijlstra wrote:
> plain text document attachment (wakeup-preempt-fiddle.patch)
> Prefer tasks that wake other tasks to preempt quickly. This improves
> performance because more work is available sooner.
> 
> The workload that prompted this patch was a kernel build over NFS4 (for some
> curious and not understood reason we had to revert commit:
> 18de9735300756e3ca9c361ef58409d8561dfe0d to make any progress at all)
> 
> Without this patch a make -j8 bzImage (of x86-64 defconfig) would take
> 3m30-ish, with this patch we're down to 2m50-ish.

Here, with wimpy 100Mbps nic and my normal config, the improvement is
considerably larger.  Full make -j8 build went from ~6m17s to ~4m28s.

	-Mike

