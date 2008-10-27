Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJ0QGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJ0QGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYJ0QGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:06:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYJ0QGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:06:00 -0400
Date: Mon, 27 Oct 2008 12:05:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
In-Reply-To: <20081027155920.GS5704@elte.hu>
Message-ID: <alpine.DEB.1.10.0810271205010.3282@gandalf.stny.rr.com>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Oct 2008, Ingo Molnar wrote:
> 
> > +	help
> > +	  This tracer helps developers to analyize and optimize the kernels
> > +	  power management decisions, specifically the C-state and P-state
> > +	  behavior.
> 
> s/analyize/analyse

Unless Britsh English is different, which I do not know.

s/analyse/analyze/

;-)

-- Steve

> s/kernels/kernel's
> 
> > +static struct trace_array *power_trace;
> > +static int trace_power_enabled;
> 
> __read_mostly ?
> 
> 	Ingo
> 
> 
