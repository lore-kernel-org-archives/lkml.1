Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZDBCnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZDBCnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZDBCmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:42:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42443 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZDBCmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:42:51 -0400
Date: Wed, 1 Apr 2009 22:42:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-tip-commits@vger.kernel.org,
       stable@kernel.org
Subject: Re: [tip:tracing/syscalls] tracing/core: fix early free of
 cpumasks
In-Reply-To: <20090402015531.GA12489@elte.hu>
Message-ID: <alpine.DEB.2.00.0904012203250.30963@gandalf.stny.rr.com>
References: <1237164303-11476-1-git-send-email-fweisbec@gmail.com> <tip-2fc1dfbe17e7705c55b7a99da995fa565e26f151@git.kernel.org> <20090402011232.GA32066@goodmis.org> <20090402015531.GA12489@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This never made it into 2.6.29, nor do I see it yet in mainline.
> > 
> > This can cause unpredictable results with ftrace. We are freeing a 
> > cpu mask that will be later used.
> 
> Yes ... but CONFIG_OFFSTACK is only possible as a debug option right 
> now. So it's far less serious of an issue, it needs 2-3 unlikely 
> features to be combined.

And unfortunately for Johannes, he must have had all those features 
configured :-/  He spent pretty much the entire day trying to figure out 
why ftrace was broken.

-- Steve

> 
> The fix looks simple enough, so once the tracing tree is upstream, 
> we can forward it to -stable.
> 
> 	Ingo
> 
