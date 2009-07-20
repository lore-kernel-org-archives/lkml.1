Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZGTPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZGTPiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZGTPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:38:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZGTPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:38:53 -0400
Date: Mon, 20 Jul 2009 11:38:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tracing/events: 2 fixes for dynamic arrays
In-Reply-To: <4A63C5CD.7010204@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907201138340.7595@gandalf.stny.rr.com>
References: <4A5E9604.2030103@cn.fujitsu.com> <4A63C5CD.7010204@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Jul 2009, Li Zefan wrote:

> Hi Steven,
> 
> Could you have a look at these 2 patches?

Thanks Li,

I just pulled them in

-- Steve

> 
> > These 2 fixes are necessary to make __dynamic_array/__string
> > parsable for users.
> > 
> > And also fix to pass the correct string length when filtering
> > on dynamic strings.
> > 
> > [PATCH 1/2] tracing/events: add missing type info of dynamic arrays
> > [PATCH 2/2] tracing/events: record the size of dynamic arrays
> > ---
> >  include/trace/ftrace.h             |   18 ++++++++++--------
> >  kernel/trace/trace_events_filter.c |    6 ++++--
> >  2 files changed, 14 insertions(+), 10 deletions(-)
> 
