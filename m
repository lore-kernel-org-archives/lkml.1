Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbYJJQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbYJJQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYJJQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:53:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbYJJQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:53:11 -0400
Date: Fri, 10 Oct 2008 12:53:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] tracepoint: Check if the probe has been registered
In-Reply-To: <20081010140023.GA13137@elte.hu>
Message-ID: <alpine.DEB.1.10.0810101252320.21101@gandalf.stny.rr.com>
References: <20081010111631.78545D1BDA2@perso1.free.fr> <20081010140023.GA13137@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Oct 2008, Ingo Molnar wrote:

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

Hmm, my email was on the fritz for this one. I'll have to search for it on 
a mailing list web site to see the patch.

-- Steve

