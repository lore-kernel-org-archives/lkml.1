Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYJJPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYJJPnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbYJJPn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:43:27 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:46042 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbYJJPn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:43:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGAT70hMQWq+/2dsb2JhbACBcrtxgWw
Date: Fri, 10 Oct 2008 11:43:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/6] tracepoint: Check if the probe has been registered
Message-ID: <20081010154325.GC18353@Krystal>
References: <20081010111631.78545D1BDA2@perso1.free.fr> <20081010140023.GA13137@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081010140023.GA13137@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:42:53 up 127 days, 20:23,  8 users,  load average: 1.42, 1.31,
	1.21
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > If we try to remove a probe that has not been already registered, the 
> > tracepoint_entry_remove_probe() function will dereference a NULL 
> > pointer. Check the probe before removing it to avoid crashes.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/tracepoint.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> applied to tip/tracing/tracepoints, thanks Frederic!
> 
> Mathieu, Steve, any objections/observations?
> 

Looks good to me. Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
