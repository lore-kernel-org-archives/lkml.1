Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZIWPYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZIWPYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZIWPYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:24:08 -0400
Received: from fifo99.com ([67.223.236.141]:40341 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZIWPYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:24:07 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <4ABA3ACF.50106@redhat.com>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net>
	 <1253663739.4317.12.camel@desktop> <20090922180611.7a47adcc@tpl.lwn.net>
	 <1253666423.25689.30.camel@desktop> <4ABA0AA6.3010408@redhat.com>
	 <20090923122530.GB6390@elte.hu> <1253717459.20648.39.camel@desktop>
	 <4ABA37A5.4000806@redhat.com> <1253718532.20648.46.camel@desktop>
	 <4ABA3ACF.50106@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 08:24:05 -0700
Message-Id: <1253719445.20648.57.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 18:12 +0300, Avi Kivity wrote:
> On 09/23/2009 06:08 PM, Daniel Walker wrote:
> >
> >> Not true, you want to address the major issues first.  What's the point
> >> of fixing whitespace if the whole approach is rejected? if it has to
> >> undergo a rewrite? (not an opinion on EDF btw, just as an example)
> >>      
> > I'm not sure why your fixated on whitespace , but thinking about it more
> > I don't think it matters .. If you fix whitespace or major issues first,
> > it doesn't matter .. All the issues have to eventually get fixed .. Not
> > to mentioned that LKML is not something you could remotely control in
> > that way.
> >    
> 
> A technical issue is that if you rewrite the code the whitespace fix 
> becomes irrelevant.  But more important is that it's a distraction when 
> people are thinking about requirements and design.

It's not irrelevant, since a person doing that rewrite will be
conscience of whitespace during the re-write ..

The same with general coding style, if someone does a rewrite who has
been alerted to checkpatch problems they will likely use it themselves
leaving no need for someone else to comment on it.

> >>> In this case the author is not totally aware of how to submit this
> >>> code.. I don't think it's at all inappropriate to comment on that. His
> >>> next submission will likely be much cleaner and nicer. It may even speed
> >>> up the inclusion process since he'll be more easily able to submit the
> >>> code (with practice and comments from us).
> >>>
> >>>        
> >> Give people some credit.
> >>      
> > What do you mean?
> >
> >    
> 
> If he's able to write a scheduling class, he'll pick up the coding style 
> when it becomes relevant.

There's plenty of large projects that never get off the ground cause
people don't follow the coding style, or don't write clean code.. Take a
look at the staging tree there's plenty of large dirty projects in
there.

Daniel 

