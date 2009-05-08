Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZEHBYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZEHBYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZEHBYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:24:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZEHBYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:24:12 -0400
Date: Thu, 7 May 2009 21:24:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] tracing: add hierarchical enabling of events
In-Reply-To: <alpine.DEB.2.00.0905072120580.28378@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0905072123360.28378@gandalf.stny.rr.com>
References: <20090507031335.815354104@goodmis.org> <20090507031434.807772092@goodmis.org> <4A025AAC.2000201@cn.fujitsu.com> <alpine.DEB.2.00.0905070912120.32734@gandalf.stny.rr.com> <4A0386A8.6030501@cn.fujitsu.com>
 <alpine.DEB.2.00.0905072120580.28378@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Steven Rostedt wrote:
> 
> > 
> > >>> +	ret = ftrace_set_clr_event(command, val);
> > >> I think we should pass "sched:" or "sched:*", instead of "sched",
> > >> the comment in ftrace_set_clr_event():
> > >>
> > >>          *  <name> (no ':') means all events in a subsystem with
> > >>          *  the name <name> or any event that matches <name>
> > > 
> > > Yeah, I thought about it too. But writing the patch in 15 minutes, I 
> > > decided that a "kstrdup" was easier than adding a ":" ;-)
> > > 
> > 
> > I think we can just avoid any kstrdup() or kmalloc(). I'll send a patch.
> 
> Hmm, careful. The ftrace_set_clr_event will modify the string passed in.

Also note, I already updated it to use ":*". You should have received a 
notice from "tip-bot".

-- Steve

