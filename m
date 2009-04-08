Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbZDHQiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbZDHQiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZDHQhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:37:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZDHQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:37:53 -0400
Date: Wed, 8 Apr 2009 12:37:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] x86, function-graph: only save return values
 on x86_64
In-Reply-To: <20090408160915.GD16759@elte.hu>
Message-ID: <alpine.DEB.2.00.0904081234550.5797@gandalf.stny.rr.com>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com> <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com>
 <20090408160915.GD16759@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Ingo Molnar wrote:

> 
> (replying to old mail - working down my awful email backlog)
> 
> do we still need this for -tip?
> 

I've ran it without issues. It will help speed up the function graph 
tracer since it removes a bunch of copies at every function call. But I 
would test it in your work suite, since I only tested it on two boxes.

-- Steve

