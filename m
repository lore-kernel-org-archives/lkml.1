Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbZAPTmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbZAPTmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZAPTmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:42:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46074 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZAPTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:42:09 -0500
Date: Fri, 16 Jan 2009 17:41:51 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090116194151.GG6562@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090116181611.GE6562@ghostprotocols.net> <alpine.DEB.1.10.0901161414190.22303@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901161414190.22303@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 16, 2009 at 02:15:55PM -0500, Steven Rostedt escreveu:
> 
> Arnaldo,
> 
> Cool stuff!
> 
> On Fri, 16 Jan 2009, Arnaldo Carvalho de Melo wrote:
> 
> > Hi Jens,
> > 
> > 	The patch below adds a ftrace interface for blktrace, allowing
> > people to use it without any required userspace tools, using sysfs to setup the
> > act_mask, pid, start_lba, end_lba.
> > 
> > 	Example usage:
> > 
> > [root@f10-1 ~]# mount -t debugfs none /sys/kernel/debug/
> 
> I think you are the only person that mounts debugfs on the "official"
> location ;-)
> 
> > [root@f10-1 ~]# ls /sys/block/sda/sda1/trace/
> > act_mask  enable  end_lba  pid  start_lba
> > [root@f10-1 ~]# cat /sys/kernel/debug/tracing/available_tracers 
> > blk function_graph wakeup function sched_switch nop
> > [root@f10-1 ~]# echo blk > /sys/kernel/debug/tracing/current_tracer 
> 
> You must like to type.

Nah, autocompletion and 'set -o vi' command line editing makes it easy,
but yes, one could mount it as:

# mkdir /d
# mount -t debugfs none /d

:-)

Other than that, I guess the implementation must be OK, huh? :-)

Well, off to play fat boys soccer.

- Arnaldo 
