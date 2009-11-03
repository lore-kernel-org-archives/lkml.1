Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZKCE0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZKCE0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZKCE0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:26:14 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60112 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZKCE0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:26:13 -0500
Date: Tue, 03 Nov 2009 13:26:14 +0900 (JST)
Message-Id: <20091103.132614.547730224103939412.mitake@dcl.info.waseda.ac.jp>
To: efault@gmx.de
Cc: mingo@elte.hu, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH][RFC] Adding benchmark subsystem to perf
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1257171969.8623.11.camel@marge.simson.net>
References: <200911022357.36541.rusty@rustcorp.com.au>
	<20091102.225129.149607581235026541.mitake@dcl.info.waseda.ac.jp>
	<1257171969.8623.11.camel@marge.simson.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RFC] Adding benchmark subsystem to perf
Date: Mon, 02 Nov 2009 15:26:09 +0100

> Hi,
> 
> On Mon, 2009-11-02 at 22:51 +0900, Hitoshi Mitake wrote:
> 
> > Example of usage:
> > % perf bench sched -t -l 1000
> > 2.863
> 
> I think this should allow other benchmarks to be added is a logical
> manner.  Perhaps perf bench -t hackbench -t -l 1000, ie bench should
> process args to allow the user to select a benchmark from a suite, and
> pass args to it as well, but with a default set built in so people can
> just type perf bench -t foo, to run any benchmark with it's defaults.

Thanks for your comment, Mike.

I forgot to do that. So I prepared new patch series
to implement your suggestion.

The new patch series containts new benchmark program,
based on Ingo's pipe-test-1m.c
http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c

And the series became too big to pack into one mail.
So I'll send it in new thread. Please wait a minute.
