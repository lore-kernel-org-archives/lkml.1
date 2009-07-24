Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZGXAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZGXAlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZGXAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:41:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZGXAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:41:14 -0400
Date: Thu, 23 Jul 2009 20:41:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 1/2] function-graph: fix the output of
 set_graph_function
In-Reply-To: <4A69027A.305@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907232040520.8469@gandalf.stny.rr.com>
References: <4A66D004.7020205@cn.fujitsu.com> <alpine.DEB.2.00.0907232034510.8469@gandalf.stny.rr.com> <4A69027A.305@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Jul 2009, Li Zefan wrote:

> Steven Rostedt wrote:
> > On Wed, 22 Jul 2009, Li Zefan wrote:
> > 
> >> It always shows "ftrace_graph_funcs":
> >>
> >>  # echo 'sys_open' > set_graph_function
> >>  # cat set_graph_function
> >>  ftrace_graph_funcs
> > 
> > Nice fix. Hmm, this probably should go into 31.
> > 
> 
> The bug is introduced by a patch in tracing/core,
> so this fix is for -tip only. :)

OK, thanks for telling me that. It makes it easier for the queue.

-- Steve

