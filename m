Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbZDGEZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbZDGEZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZDGEY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:24:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbZDGEY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:24:58 -0400
Date: Mon, 6 Apr 2009 21:20:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Linus Torvalds wrote:
> 
> Andrew, I'll continue to bisect. Looks like it might be the epoll changes 
> (that's the only really 'core' thing there). Although I don't understand 
> why those would make that Mac Mini unhappy, but not affect the other 
> machines. So maybe I should just stop guessing until the bisection ends..

It bisected past them. I'm getting worried that it's timing-related, 
because nothing that remains looks even remotely interesting for that Mac 
mini, but right now:

 - bad: 56fcef75117a153f298b3fe54af31053f53997dd
 - good: bb233fdfc7b7cefe45bfa2e8d1b24e79c60a48e5

and there's not a whole lot of commits in between.

		Linus
