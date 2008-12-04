Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYLDPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYLDPrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYLDPr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:47:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYLDPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:47:29 -0500
Date: Thu, 4 Dec 2008 10:47:27 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
In-Reply-To: <20081204153626.GB18293@elte.hu>
Message-ID: <alpine.DEB.1.10.0812041045490.19693@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org> <20081204153626.GB18293@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Ingo Molnar wrote:
> > >
> > >> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
> > >> 
> > >> eh?
> > >
> > > all side-effects of getting rid of the integer based PID namespace 
> > > and replacing them with struct pid pointers.
> > 
> > Thanks for asking Andrew it looks like an unnecessary side effect.
> 
> Will wait for how the end result looks like ;-)

I'm waiting on a fix for fork.c. I already wrote the code in ftrace when 
the fork code is fixed. It does clean it up nicely. But I do not know all 
the intricacies of the struct pid code to do the fork code correctly.

-- Steve

