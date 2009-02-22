Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZBVDZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZBVDZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 22:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZBVDZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 22:25:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47087 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZBVDZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 22:25:02 -0500
Date: Sun, 22 Feb 2009 12:23:55 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20090220172241.GF24538@elte.hu>
References: <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
Message-Id: <20090222121821.3599.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

(cc to Frank and Mathieu)

> > >  config MARKERS
> > >  	bool "Activate markers"
> > > -	depends on TRACEPOINTS
> > > +	select TRACEPOINTS
> > >  	help
> > >  	  Place an empty function call at each marker site. Can be
> > >  	  dynamically changed for a probe function.
> > 
> > but using "select" instead of "depends on" just causes the 
> > kind of problem that you described, whereas using "depends on" 
> > does follow dependency chains.
> 
> Well, as long as the secondary selects are 'expanded' along the 
> line of dependencies, it should still be fine. With an 
> increasing number of dependencies it quickly becomes ugly 
> though. This might be one of the cases where it works.
> 
> Eventually we should eliminate markers, their uses can either be 
> converted to new-style tracepoints, or to ftrace_printk().

IIRC, this suggestion still don't get agreement of all tracing feature stakeholder.
We need to definitely discuss more lot and deep.
so I wonder why don't we create linux-tracing new mailing list.

tracer feature perfectly have new ML creation condition
  - very active development
  - many stakeholder and developer
  - use many common parts (eg, marker, kprobe, unified buffer)




