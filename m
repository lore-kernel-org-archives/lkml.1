Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZCRPpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZCRPpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZCRPpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:45:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:54008 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZCRPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:45:22 -0400
Date: Wed, 18 Mar 2009 08:46:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for March 11 (tracing)
Message-Id: <20090318084651.3dbf01e3.randy.dunlap@oracle.com>
In-Reply-To: <1236875181.11290.1.camel@localhost.localdomain>
References: <20090311225913.51589223.sfr@canb.auug.org.au>
	<49B7F691.5000305@oracle.com>
	<49B93584.3020302@oracle.com>
	<1236875181.11290.1.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49C116E7.0128:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 12:26:21 -0400 Steven Rostedt wrote:

> 
> On Thu, 2009-03-12 at 09:17 -0700, Randy Dunlap wrote:
> > [adding cc:s]
> > 
> > [same report for March 12]
> > 
> > Randy Dunlap wrote:
> > > Stephen Rothwell wrote:
> > >> Hi all,
> > >>
> > >> Changes since 20090310:
> > > 
> > > 
> > > Building on i386 generates a ton of printk format warnings:
> > > 
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
> > > kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'
> > > 
> 
> I believe this is corrected in Ingo's tip tree. I changed %lu to %zu to
> handle the "sizeof()" case. The fix was suggested by Andrew Morton.


This build warning is still around (20090318).
Is the fix not in some branch that is imported into linux-next or what?

Thanks,
---
~Randy
