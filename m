Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZILSFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZILSFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZILSFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:05:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZILSFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:05:05 -0400
Subject: Re: [tip:tracing/core] x86/tracing: comment need for atomic nop
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       srostedt@redhat.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090912134515.GC22876@Krystal>
References: <tip-fc06b8520b3bf9aaeb2e27debe6719c215bd4916@git.kernel.org>
	 <20090912134515.GC22876@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 12 Sep 2009 14:05:06 -0400
Message-Id: <1252778706.18996.754.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:45 -0400, Mathieu Desnoyers wrote:
> * tip-bot for Steven Rostedt (srostedt@redhat.com) wrote:
> > Commit-ID:  fc06b8520b3bf9aaeb2e27debe6719c215bd4916
> > Gitweb:     http://git.kernel.org/tip/fc06b8520b3bf9aaeb2e27debe6719c215bd4916
> > Author:     Steven Rostedt <srostedt@redhat.com>
> > AuthorDate: Thu, 10 Sep 2009 17:22:44 -0400
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Thu, 10 Sep 2009 17:22:44 -0400
> > 
> > x86/tracing: comment need for atomic nop
> > 
> > The dynamic function tracer relys on the macro P6_NOP5 always being
> > an atomic NOP. If for some reason it is changed to be two operations
> > (like a nop2 nop3) it can faults within the kernel when the function
> > tracer modifies the code.
> > 
> > This patch adds a comment to note that the P6_NOPs are expected to
> > be atomic. This will hopefully prevent anyone from changing that.
> > 
> > Reported-by: Mathieu Desnoyer <mathieu.desnoyers@polymtl.ca>
> 
> With an added "s" to my last name, that will be good.

Oops, sorry. I seem to always do that to your name. I was too busy
concentrating in getting your email correct (wrote the commit on a
different box than my email client) that I didn't notice your name was
wrong.

-- Steve

> 
> Thanks !
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


