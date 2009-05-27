Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbZE0Nrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbZE0Nrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761764AbZE0Nrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:47:39 -0400
Received: from www.tglx.de ([62.245.132.106]:38468 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762816AbZE0Nrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:47:39 -0400
Date: Wed, 27 May 2009 15:46:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Anton Blanchard <anton@samba.org>, rostedt@goodmis.org, mingo@elte.hu,
       tzanussi@gmail.com, jbaron@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
 tracepoints
In-Reply-To: <20090526180600.GA5969@nowhere>
Message-ID: <alpine.LFD.2.00.0905271545230.3397@localhost.localdomain>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526180600.GA5969@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Frederic Weisbecker wrote:

> On Tue, May 26, 2009 at 02:26:43PM +1000, Anton Blanchard wrote:
> > 
> > Add tracepoints for timer and high res timer execution. We add entry and
> > exit tracepoints so we can calculate timer latency.
> 
> 
> Your work looks very similar to Xiao Guangrong's patches.
> 
> See:
> 
> ftrace: add tracepoint for timer
> ftrace: add tracepoint for itimer
> ftrace: add tracepoint for hrimer
> 
> I'm not sure which one should be picked between
> his patches and yours.

Actually we want a combination of both.

Thanks,
	 tglx
