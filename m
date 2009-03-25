Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbZCYOWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbZCYOWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762006AbZCYOSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142AbZCYOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:40 -0400
Date: Wed, 25 Mar 2009 10:18:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Credit for vsprintk work
In-Reply-To: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903251016540.5675@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 25 Mar 2009, Steven Rostedt wrote:

> 
> Frederic,
> 
>  $ git blame lib/vsprintf.c |grep 'Frederic Weisbecker' | wc -l
> 542
> 
> You did a hell of a lot of work on vsprintf.c, and you are still too 
> modest to put in a copyright at the top.
> 
> I know some people think that git is good enough for ownership. But 
> really, the amount of changes that you did in vsprintf.c deserves a bit of 
> credit in the source file.
> 
> Is everyone OK if a copyright goes at the top of this file giving credit 
> to Frederic?  If for anything else, it will facilitate people to find who 
> broke it if it breaks ;-)
> 
> I think Frederic should send one more patch to add his copyright. That is, 
> of course, if Frederic wants too.
> 
> Note, Frederic did not ask me to post this. In fact, this is the first 
> time he's seen this complaint. I'm posting this because I was showing this 
> code to some students at a University and when I wanted to point out 
> who wrote it, I was surprised that Frederic's name was not mentioned.
> I was looking at the code via LXR so git was not helpful here.

Lai also did this work too, so I recommend adding something like:

 * Binary printk modifications, copyright 2009:
 *  Frederic Weisbecker <fweisbec@gmail.com>
 *  Lai Jiangshan <laijs@cn.fujitsu.com>

Or something similar.

-- Steve

