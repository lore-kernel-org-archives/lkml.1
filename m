Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZJELSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZJELSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZJELSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:18:07 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:9985 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZJELSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:18:06 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] sched: Set correct normal_prio and prio values in
 sched_fork()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
In-Reply-To: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 13:20:22 +0200
Message-Id: <1254741622.26976.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 06:47 +0000, Peter Williams wrote:
> normal_prio should be updated if policy changes from RT to SCHED_MORMAL
> or if static_prio/nice is changed.  Some paths through sched_fork()
> ignore this requirement and may result in normal_prio having an invalid
> value.
> 
> Fixing this issue allows the call to effective_prio() in
> wake_up_new_task() to be removed.
> 
> Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

/me twists his brain into a pretsel, squints his eyes and sees its
obvious ;-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thank Peter!

