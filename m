Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXJKBU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXJKBU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 21:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXJKBUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 21:20:48 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:39014 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXJKBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 21:20:47 -0400
Subject: Re: Linux 2.6.23
From: Nicholas Miell <nmiell@comcast.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071010101452.GA25433@elte.hu>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
	 <1191996740.8694.7.camel@entropy>  <20071010101452.GA25433@elte.hu>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 18:20:42 -0700
Message-Id: <1192065642.2695.9.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-10 at 12:14 +0200, Ingo Molnar wrote:
> * Nicholas Miell <nmiell@comcast.net> wrote:
> 
> > Does CFS still generate the following sysbench graphs with 2.6.23, or 
> > did that get fixed?
> >
> > http://people.freebsd.org/~kris/scaling/linux-pgsql.png 
> > http://people.freebsd.org/~kris/scaling/linux-mysql.png
> 
> as far as my testsystem goes, v2.6.23 beats v2.6.22.9 in sysbench:
> 
>     http://redhat.com/~mingo/misc/sysbench.jpg

That's nice to know. Note that I'm not actually involved in any of these
tests, just a somewhat interested bystander.

> 
> As you can see it in the graph, v2.6.23 schedules much more consistently 
> too. [ v2.6.22 has a small (but potentially statistically insignificant) 
> edge at 4-6 clients, and CFS has a slightly better peak (which is 
> statistically insignificant). ]
> 
> ( Config is at http://redhat.com/~mingo/misc/config, system is Core2Duo
>   1.83 GHz, mysql-5.0.45, glibc-2.6. Nothing fancy either in the config
>   nor in the setup - everything is pretty close to the defaults. )
> 
> i'm aware of a 2.6.21 vs. 2.6.23 sysbench regression report, and it 
> apparently got resolved after various changes to the test environment:
> 
>    http://jeffr-tech.livejournal.com/10103.html
> 
>  " [<CFS>] has virtually no dropoff and performs better under load than
>    the default 2.6.21 scheduler. " (paraphrased)
> 
> (The new link you posted, just a few hours after the release of v2.6.23, 
> has not been reported to lkml before AFAICS - when did you become aware 
> of it? If you learned about it before v2.6.23 it might have been useful 
> to report it to the v2.6.23 regression list.)

According to my IRC logs, Jeffr pasted the URL at Oct 09 22:53:56 PDT.
He says he tried to contact you early in CFS's development, but got no
reply.

> At a quick glance there are no .configs or other testing details at or 
> around that URL that i could use to reproduce their result precisely, so 
> at least a minimal bugreport would be nice.
> 

AFAICT, the configuration is described in
http://people.freebsd.org/~kris/scaling/mysql.html


-- 
Nicholas Miell <nmiell@comcast.net>

