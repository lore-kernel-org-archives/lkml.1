Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYJXOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYJXOrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYJXOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:47:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYJXOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:47:39 -0400
Date: Fri, 24 Oct 2008 10:47:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock
 tracer
In-Reply-To: <20081024143744.GA20768@redhat.com>
Message-ID: <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com>
References: <48F10B0B.406@gmail.com> <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com> <y0mmygv18le.fsf@ton.toronto.redhat.com> <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com> <20081024143744.GA20768@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Oct 2008, Frank Ch. Eigler wrote:

> Hi -
> 
> On Fri, Oct 24, 2008 at 03:43:49PM +0200, Fr?d?ric Weisbecker wrote:
> 
> > > [...]  For comparison, this is how this sort of analysis may be
> > > done with systemtap [...]
> 
> > That's a great and powerful tool.
> > 
> > But just one sorrow:
> > I just think that's a pity that we have to use/learn a new scripting
> > language to use it.
> 
> I understand.
> 
> > I would rather prefer to use an API that provides functions/objects
> > for most common scripting languages.
> 
> That is an interesting idea.  One possible problem is that the final
> complete script "program" needs to be translated to something that can
> run quickly and safely inside the kernel.  Full python or perl runtime
> + libraries would have been almost certainly unbearable.

Why can't the userspace application convert the script to something easy 
that the kernel can handle?  But have the user application interface be 
very simple, and perhaps even use perl or python.

-- Steve

