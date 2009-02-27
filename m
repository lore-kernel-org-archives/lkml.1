Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZB0DOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZB0DOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZB0DOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:14:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42341 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZB0DOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:14:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Dominique Toupin" <dominique.toupin@ericsson.com>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com, "Steven Rostedt" <rostedt@goodmis.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Jason Baron" <jbaron@redhat.com>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <acme@ghostprotocols.net>
In-Reply-To: <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se>
References: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com> <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se>
Message-Id: <20090227121053.152B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 12:14:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Given this scenario :
> > > 
> > > A telecommunication system runs, but the client notices 
> > something wrong.
> > > They call their service provider. The provider enables tracing 
> > > _remotely_ on the _production system_ while it's _active in 
> > the field_.
> > > 
> > > Bam, those few milliseconds interrupt latencies become unacceptable.
> > > 
> > > Hopefully this scenario makes the use-case clearer. The 
> > problem is not 
> > > that interrupt latencies would occur while tracing is on, 
> > but rather 
> > > that it would happen on a running production system when switching 
> > > tracing on. This is what is totally unacceptable for this use-case.
> > > 
> > > For more details about such requirements, I'm CCing 
> > Dominique Toupin 
> > > from Ericsson who I'm sure would be happy to give more 
> > details about 
> > > this if needed.
> > 
> > Hmm, so this system in the field is running Linux with the 
> > Real-Time Patch?  Because if it isn't it will suffer from 
> > millisecond latencies in normal operation.
>
> In many cases we don't use Linux real-time, we have many systems that
> are soft-real-time an non real-time Linux is good enough.
>  

Agreed, rt-patch seems off topics. we discuss to mainline kernel.

Steven, I sitll think nobody use ftrace on production system now yet.
Do you know actual production user?




