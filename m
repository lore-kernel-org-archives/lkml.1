Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbZKXOQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbZKXOQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932983AbZKXOQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:16:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbZKXOQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:16:42 -0500
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run
 producer/consumer threads at nice +19
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
References: <new-submission>
	 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 09:16:47 -0500
Message-Id: <1259072207.22249.1066.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 07:15 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  98e4833ba3c314c99dc364012fba6ac894230ad0
> Gitweb:     http://git.kernel.org/tip/98e4833ba3c314c99dc364012fba6ac894230ad0
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 23 Nov 2009 08:03:09 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Nov 2009 08:03:09 +0100
> 
> ring-buffer benchmark: Run producer/consumer threads at nice +19
> 
> The ring-buffer benchmark threads run on nice 0 by default, using
> up a lot of CPU time and slowing down the system:
> 
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   1024 root      20   0     0    0    0 D 95.3  0.0   4:01.67 rb_producer
>   1023 root      20   0     0    0    0 R 93.5  0.0   2:54.33 rb_consumer
>  21569 mingo     40   0 14852 1048  772 R  3.6  0.1   0:00.05 top
>      1 root      40   0  4080  928  668 S  0.0  0.0   0:23.98 init
> 
> Renice them to +19 to make them less intrusive.

Ingo, that is the point of a benchmark!

This module is not made to be run all the time. I know you do it for
testing. But running it at lowest priority kills the reason this module
was made in the first place!

-- Steve


