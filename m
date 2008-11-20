Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYKTTYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYKTTYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYKTTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:24:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYKTTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:24:47 -0500
Date: Thu, 20 Nov 2008 14:24:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 0/5] powerpc: dynamic ftrace port
In-Reply-To: <20081120191650.GD3955@elte.hu>
Message-ID: <alpine.DEB.1.10.0811201423010.3378@gandalf.stny.rr.com>
References: <20081120190948.057007623@goodmis.org> <20081120191650.GD3955@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Ingo Molnar wrote:
> > 
> > There is one exception and that is for the first patch. The first patch
> > is actually a fix for the irqsoff latency tracer which is already
> > in mainline for PowerPC.
> > 

> > Steven Rostedt (5):
> >       powerpc: ftrace, do not latency trace idle

> 
> Now lets hope it looks good to Paul too and we can get his Acked-by
> :-)
> 

Hmm, that first patch is really a bug fix. I wonder if we should push to 
get that into 28?  It has a low impact, but it fixes a bug that is in 
current mainline.

-- Steve

