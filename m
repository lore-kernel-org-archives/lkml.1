Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZCLQ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZCLQ11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbZCLQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:26:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbZCLQ0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:26:53 -0400
Subject: Re: linux-next: Tree for March 11 (tracing)
From: Steven Rostedt <srostedt@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49B93584.3020302@oracle.com>
References: <20090311225913.51589223.sfr@canb.auug.org.au>
	 <49B7F691.5000305@oracle.com>  <49B93584.3020302@oracle.com>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 12 Mar 2009 12:26:21 -0400
Message-Id: <1236875181.11290.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-03-12 at 09:17 -0700, Randy Dunlap wrote:
> [adding cc:s]
> 
> [same report for March 12]
> 
> Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Changes since 20090310:
> > 
> > 
> > Building on i386 generates a ton of printk format warnings:
> > 
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
> > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'
> > 

I believe this is corrected in Ingo's tip tree. I changed %lu to %zu to
handle the "sizeof()" case. The fix was suggested by Andrew Morton.

-- Steve


