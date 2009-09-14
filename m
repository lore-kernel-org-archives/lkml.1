Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZINOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZINOFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZINOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:05:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:38917 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754957AbZINOFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:05:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18wF4UKjcEwZxOH4XqITdilVeVveUnUA1Y9JUGeWo
	YtoSj/qRF0dmoZ
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
From: Mike Galbraith <efault@gmx.de>
To: pavel@pavlinux.ru
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <200909141742.45487.pavel@pavlinux.ru>
References: <200909141742.45487.pavel@pavlinux.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 16:05:40 +0200
Message-Id: <1252937140.6500.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're asking Ingo a question, maybe a CC is in order.

On Mon, 2009-09-14 at 17:42 +0400, Pavel Vasilyev wrote:
> 
> Next patсh -  
> http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2F%2Fv2.6%2Fsnapshots%2Fpatch-2.6.31-git2.bz2;z=548
> 
> This patch defines the core processes that are working with nice leve equal to 
> zero , as in the BFS. :)
> 
> Why?

I did that, not Ingo, and did so because with kthreads that use
diddly-spit CPU (every one I see), it's just a waste of math.  What
kthreads are you seeing using so much CPU that their weight is a factor?
They _should_ be able to preempt and get their work done just fine
without a boost.

> VirtualBox, Vmware, QEMU, Firefox, Azureus, and many subsystems and 
> applications began working with large timeouts. In appearance similar to 
> hang.

In any case, if it's causing problems, reverting is easy enough, though
better would be to find out the why.

	-Mike


