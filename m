Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYGKHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYGKHzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYGKHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:55:40 -0400
Received: from ozlabs.org ([203.10.76.45]:44540 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYGKHzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:55:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Date: Fri, 11 Jul 2008 17:51:14 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <4875582D.4040901@qualcomm.com>
In-Reply-To: <4875582D.4040901@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111751.14728.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 10:30:37 Max Krasnyansky wrote:
> Rusty Russell wrote:
> > stop_machine creates a kthread which creates kernel threads.  We can
> > create those threads directly and simplify things a little.  Some care
> > must be taken with CPU hotunplug, which has special needs, but that code
> > seems more robust than it was in the past.
> >
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Rusty,
>
> You mentioned (in private conversation) that you were going to add some
> logic that checks whether CPU is running user-space code and not holding
> any locks to avoid scheduling stop_machine thread on it. Was it supposed
> to be part of this patch ?
>
> Max

No... I tried it, and it killed my machine.  I didn't chase it for the moment, 
but it's on the "experimental" end of my patch queue.

Will play with it again and report,
Rusty.




