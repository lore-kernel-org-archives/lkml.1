Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbZKXPA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbZKXPA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbZKXPA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:00:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbZKXPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:00:55 -0500
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run
 producer/consumer threads at nice +19
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091124143923.GA17934@elte.hu>
References: <new-submission>
	 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
	 <1259072207.22249.1066.camel@gandalf.stny.rr.com>
	 <20091124143923.GA17934@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 10:01:00 -0500
Message-Id: <1259074860.22249.1071.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 15:39 +0100, Ingo Molnar wrote:

> > This module is not made to be run all the time. I know you do it for 
> > testing. But running it at lowest priority kills the reason this 
> > module was made in the first place!
> 
> Well, it also found quite a few bugs in the ring-buffer code, beyond 
> benchmarking so i'd like to use it even without looking at the numbers.

OK, then lets make a module option (and command line) that will allow
the setting of the priority of the threads. Either nice or even fifo
(use at your own risk ;-)

I can write something up for that.

-- Steve


