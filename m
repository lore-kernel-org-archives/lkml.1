Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYJXOiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYJXOiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJXOh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:37:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYJXOh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:37:56 -0400
Date: Fri, 24 Oct 2008 10:37:44 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, systemtap@sources.redhat.com
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Message-ID: <20081024143744.GA20768@redhat.com>
References: <48F10B0B.406@gmail.com> <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com> <y0mmygv18le.fsf@ton.toronto.redhat.com> <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Oct 24, 2008 at 03:43:49PM +0200, Frédéric Weisbecker wrote:

> > [...]  For comparison, this is how this sort of analysis may be
> > done with systemtap [...]

> That's a great and powerful tool.
> 
> But just one sorrow:
> I just think that's a pity that we have to use/learn a new scripting
> language to use it.

I understand.

> I would rather prefer to use an API that provides functions/objects
> for most common scripting languages.

That is an interesting idea.  One possible problem is that the final
complete script "program" needs to be translated to something that can
run quickly and safely inside the kernel.  Full python or perl runtime
+ libraries would have been almost certainly unbearable.

- FChE
