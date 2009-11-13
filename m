Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZKMJgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZKMJgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZKMJge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:36:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39335 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZKMJge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YimPCsJrDHYp3NC73lyhQaatX0+N4+IX8rYWqQO7tjkHVqLxBwOhQJEj47B2TWtZJl
         B7LsHCGMim2bTWtKU6yZPHOkM5sFW7OKlnpviA0RG74x6a4BDg6exXuZDH9K5GbDHXaG
         8VHQNWbsmJWJfcotrdoktCVKL+2WZSqhjQ+vw=
Date: Fri, 13 Nov 2009 10:36:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [PATCH] tracing: Rename lockdep event subsystem into lock
Message-ID: <20091113093640.GB5243@nowhere>
References: <20091113085123.GA1318@elte.hu> <1258103194-843-1-git-send-email-fweisbec@gmail.com> <1258103409.4039.1079.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258103409.4039.1079.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:10:09AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-11-13 at 10:06 +0100, Frederic Weisbecker wrote:
> > Lockdep events subsystem gathers various locking related events such
> > as a request, release, contention or acquisition of a lock.
> > 
> > The name of this event subsystem is a bit of a misnomer since these
> > events are not quite related to lockdep but more generally to locking,
> > ie: these events are not reporting lock dependencies or possible
> > deadlock scenario but pure locking events.
> 
> But in order to get them you need pretty much all of lockdep, except
> PROVE_LOCKING. You get all the lock debugging, the lock tracking, the
> struct dep_map bloat etc.


Sure. But I think an event susbsystem name should reflect its
actual purpose despite the machinery that makes it work.

