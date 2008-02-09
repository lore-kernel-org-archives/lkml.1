Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYBIIGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYBIIGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYBIIGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:06:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbYBIIGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:06:30 -0500
Date: Sat, 9 Feb 2008 00:05:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] latency tracer
Message-Id: <20080209000503.f4eb2f02.akpm@linux-foundation.org>
In-Reply-To: <20080209073756.GA13141@elte.hu>
References: <20080208214522.GA31101@elte.hu>
	<20080208232306.6e8a8162.akpm@linux-foundation.org>
	<20080209073756.GA13141@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 08:37:56 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 8 Feb 2008 22:45:22 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Linus, please pull the latency tracer tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > > 
> > > Find the shortlog below.
> > > 
> > > This is the latency tracer from -rt
> > 
> > I've never seen any of this code before and googling several of the 
> > patch titles turns up this email and nothing else.
> 
> there might be some confusion here. Google for "mcount tracing utility" 
> - there's 2270 hits. There's been 8 full series posted to lkml in the 
> past month:
> 
> ..
>
> we renamed the concept to 'ftrace' during pre-merge cleanups, perhaps 
> that is what caused you to not recognize this? (mcount is a confusing 
> name and ties it to a gcc feature while there's nothing gcc specific 
> about this concept.)
> 

Oh.  That clang you heard was a penny dropping.

I'd been kind of ignoring those patches assuming I had a couple more
months.

