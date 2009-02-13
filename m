Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZBMUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZBMUDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbZBMUDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:03:15 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:48038 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZBMUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oj3z4OSyKKnHcm77gM5fbQfuopfZYQn7IA3npWpU49cam03lQ79sjwk39c/eVKDYHU
         5a69SPamYG2mwgLZYr9sqevjwG+oEeS5cfOFah4QAXP0vRE6A52IqnDbVgj9AeITDSie
         h/cDS3h+PNe/ullQDF8GpNs23TvTQ1MSS68EM=
Date: Fri, 13 Feb 2009 21:03:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: sysprof hrtimer fix
Message-ID: <20090213200305.GA5833@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <20090213004812.GA5824@nowhere> <20090213021626.GA5807@nowhere> <20090213030919.GA5826@nowhere> <20090213072601.GA26946@elte.hu> <20090213120451.GA5782@nowhere> <20090213124928.GC5483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213124928.GC5483@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 01:49:28PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > So, just a thing.
> > -rt make the hrtimer's timers running on softirq context because the hrtimer_interrupt
> > doesn't run as a threaded interrupt, and then it is not preemptible right?
> > 
> > In that case, sysprof will continue to run in hardirq context, as before, and
> > it will considerably increase the latency. And that matters here.
> > So I think it is important to put it on the reminder:
> 
> hm, not sure. Do you know it numerically how much worst-case overhead it
> induces?
> 
> 	Ingo

Not at all.
But when I find some time, I will compare some rt average tests with and without sysprof.

