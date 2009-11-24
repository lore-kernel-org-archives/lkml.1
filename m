Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbZKXOUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbZKXOUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932983AbZKXOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:20:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbZKXOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:20:13 -0500
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run
 producer/consumer threads at nice +19
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1259072207.22249.1066.camel@gandalf.stny.rr.com>
References: <new-submission>
	 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
	 <1259072207.22249.1066.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 09:20:18 -0500
Message-Id: <1259072418.22249.1068.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:16 -0500, Steven Rostedt wrote:

> > Renice them to +19 to make them less intrusive.
> 
> Ingo, that is the point of a benchmark!
> 
> This module is not made to be run all the time. I know you do it for
> testing. But running it at lowest priority kills the reason this module
> was made in the first place!

Note, I first wrote this where the threads ran at SCHED_FIFO (but never
published it that way). I was afraid if something went wrong, it would
lock up the system. But still, it is a benchmark module. It is for
developers and analyzers only. Not for common users.

-- Steve


