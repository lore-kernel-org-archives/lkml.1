Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZGUCOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZGUCOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZGUCOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:14:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGUCON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:14:13 -0400
Date: Mon, 20 Jul 2009 22:14:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
In-Reply-To: <4A651DF2.3060403@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907202213150.25472@gandalf.stny.rr.com>
References: <4A63D485.7030703@cn.fujitsu.com> <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com> <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com> <4A651907.1090805@cn.fujitsu.com> <alpine.DEB.2.00.0907202131390.11494@gandalf.stny.rr.com>
 <4A651DF2.3060403@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Jul 2009, Li Zefan wrote:
> >> 2:
> >>   # cat filter
> >>   irq == not_num
> >>   ^
> >>   parse_error: Couldn't find or set field in one of a subsystem's events
> > 
> > This looks good, BUT, it is too much. If you want to implement an error 
> > message like the above, it should probably be a "pr_info()" thing.
> > 
> 
> Yeah, I think it's too much too, but that's exactly what we have.
> And I posted a patch to remove those error messages, but Tom and
> Frederic didn't seem to like it:
> 
> 	http://lkml.org/lkml/2009/6/17/89
> 

Ah, I forgot about that thread. Well, Frederic did mention making a 
"filter_error" file. That sounds like a good solution to me. But I have no 
strong opinions on this one way or another.

-- Steve

