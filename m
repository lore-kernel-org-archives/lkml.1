Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZFJPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZFJPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZFJPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:21:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZFJPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:21:08 -0400
Date: Wed, 10 Jun 2009 11:21:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
In-Reply-To: <20090610143912.GB23770@Krystal>
Message-ID: <alpine.DEB.2.00.0906101113170.30552@gandalf.stny.rr.com>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
 <20090610143912.GB23770@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Mathieu Desnoyers wrote:
> > 
> > 
> > And then in the trace format, we could do:
> > 
> > 	<data:gfp:field>
> > 
> > And the 'data' will flag us to how to print the data.
> > 
> > For userland, there could be a file in:
> > 
> > 	/debug/tracing/events/data_types/gfp/format
> > 
> > That will show that format. Yes we duplicate some of the code, but it 
> > it would solve these types of issues.
> > 
> 
> It sounds a lot like the type tables LTTng is currently exporting
> through specific channels. One for the list of IRQ handlers, one listing
> softirqs, one for syscalls.... etc etc. The nice side of this approach
> is that it permits to deal with dynamic events that modify the table
> state while tracing is active, e.g. : loadling a module which adds an
> IRQ handlers.
> 
> This is planned to be used for enum description eventually.

Well, I wouldn't make it dependent on any class, just a generic type to 
add that any user could do. The types just need to be added before the 
events are registered.

-- Steve

