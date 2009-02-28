Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZB1Edk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZB1Edk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 23:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZB1Edb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 23:33:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:13557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZB1Eda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 23:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tSaInYBwup9HV1Zp9wM9vCipvv3cNMWXrdqw+GPpwpLZ5H7YvONygkwUJsFS02Pdl+
         U06H9yn+ei1LCeEXo0iWh1wQJfEoH9eCzcsT+xVgbGtumROgO17bTlfAuPaJkTFGCjtu
         5+9dQLh8CuSFgc/VzCMSgs323A4Unjc1n+S1c=
Subject: Re: [ANNOUNCE][PATCH 0 of 4] zedtrace, a general-purpose binary
	tracer
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090227164559.GB5856@nowhere>
References: <1235725238.8512.86.camel@charm-linux>
	 <20090227164559.GB5856@nowhere>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 22:33:26 -0600
Message-Id: <1235795606.9433.7.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-02-27 at 17:46 +0100, Frederic Weisbecker wrote:
> On Fri, Feb 27, 2009 at 03:00:38AM -0600, Tom Zanussi wrote:
> > 
> > Available tracepoints:
> > 
> > sched
> >   sched:kthread_stop
> >   sched:kthread_stop_ret
> >   sched:wait_task
> >   sched:wakeup
> >   sched:wakeup_new
> >   sched:switch
> >   sched:migrate_task
> >   sched:process_free
> >   sched:process_exit
> >   sched:process_wait
> >   sched:process_fork
> >   sched:signal_send
> > block
> >   block:rq_abort
> >   block:rq_insert
> >   block:rq_issue
> >   block:rq_requeue
> >   block:rq_complete
> >   block:bio_bounce
> >   block:bio_complete
> >   block:bio_backmerge
> >   block:bio_frontmerge
> >   block:bio_queue
> >   block:getrq
> >   block:sleeprq
> >   block:plug
> >   block:unplug_io
> >   block:unplug_timer
> >   block:split
> >   block:remap
> > workqueue
> >   workqueue:insertion
> >   workqueue:execution
> >   workqueue:creation
> >   workqueue:destruction
> 
> 
> You already wrote the subsystem, so I guess the subsystem: prefix
> is a bit too much. Anyway, sorting the tracepoints by subsystem is a good
> idea too.
> 

I add the subsystem prefix so you can just scrape the full event name
off the listing shown on the screen and feed it directly to the
command-line.

Good point about the sorting though, will put it on my todo list.

> > the infrastructure is there for. ;-)
> > 
> > 
> 
> 
> Great work.
>  

Thanks!



