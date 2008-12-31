Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYLaD40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYLaD40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYLaD4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 22:56:18 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56999 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYLaD4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 22:56:17 -0500
Date: Tue, 30 Dec 2008 19:56:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kmemtrace over tracepoints (resubmit)
Message-ID: <20081231035616.GD15692@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1230622068.git.eduard.munteanu@linux360.ro>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:41:26AM +0200, Eduard - Gabriel Munteanu wrote:
> Hi again,
> 
> I've figured out a way to minimally modify RCU headers. If you still think
> splitting RCU headers is a good idea, let me know, but this is meant to get
> kmemtrace in Linus' tree as soon as possible.

I am only in favor of splitting the RCU headers if someone -really-
needs it.  ;-)

So if this works, go for it!!!

							Thanx, Paul

> I also renamed tracers as Pekka suggested.
> 
> Let me know what you think.
> 
> 
> 	Cheers,
> 	Eduard
> 
> 
> Eduard - Gabriel Munteanu (2):
>   RCU: Don't include unnecessary headers, allow kmemtrace w/
>     tracepoints.
>   kmemtrace: Use tracepoints instead of markers.
> 
>  include/linux/kmemtrace.h  |   91 +++++++++++------------------------------
>  include/linux/rcuclassic.h |    1 -
>  include/linux/rcupdate.h   |    1 -
>  include/linux/rcupreempt.h |    2 +-
>  include/linux/slab_def.h   |    9 ++--
>  include/linux/slub_def.h   |   12 ++----
>  lib/Kconfig.debug          |    2 +-
>  mm/kmemtrace.c             |   96 ++++++++++++++++++++++++++++++++------------
>  mm/slab.c                  |   25 +++++------
>  mm/slob.c                  |   27 +++++-------
>  mm/slub.c                  |   30 +++++--------
>  11 files changed, 140 insertions(+), 156 deletions(-)
> 
