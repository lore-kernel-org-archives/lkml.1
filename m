Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbZKZIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbZKZIdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbZKZIdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:33:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbZKZIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:33:07 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 03:33:10 -0500
Message-Id: <1259224390.21397.87.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 08:16 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
> Gitweb:     http://git.kernel.org/tip/091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Thu, 26 Nov 2009 09:04:55 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 26 Nov 2009 09:04:55 +0100
> 
> events: Rename TRACE_EVENT_TEMPLATE() to DECLARE_EVENT_CLASS()
> 
> It is not quite obvious at first sight what TRACE_EVENT_TEMPLATE
> does: does it define an event as well beyond defining a template?
> 
> To clarify this, rename it to DECLARE_EVENT_CLASS, which follows
> the various 'DECLARE_*()' idioms we already have in the kernel:
> 
>   DECLARE_EVENT_CLASS(class)
> 
>     DEFINE_EVENT(class, event1)
>     DEFINE_EVENT(class, event2)
>     DEFINE_EVENT(class, event3)
> 
> To complete this logic we should also rename TRACE_EVENT() to:
> 
>   DEFINE_SINGLE_EVENT(single_event)
> 
> ... but in a more quiet moment of the kernel cycle.


I would like to hear what others think about this change before we go
ahead and implement it. A lot of developers have just learned about
TRACE_EVENT and now it just disappeared. Well, not really, but in the
sense of ' find linux.git -name '*.[ch]' | xargs grep TRACE_EVENT' it no
longer exists.

-- Steve


