Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYJaUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYJaUFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYJaUFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:05:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYJaUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:05:03 -0400
Date: Fri, 31 Oct 2008 16:05:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
In-Reply-To: <20081031195040.GV28946@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0810311604040.28774@gandalf.stny.rr.com>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk> <20081031185526.GT28946@ZenIV.linux.org.uk> <20081031190608.GU28946@ZenIV.linux.org.uk>
 <20081031195040.GV28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I guess this is needed to make alph (and perhasp others compile).
Can you get this ready for 2.6.28?


On Fri, 31 Oct 2008, Al Viro wrote:

> On Fri, Oct 31, 2008 at 07:06:08PM +0000, Al Viro wrote:
> > On Fri, Oct 31, 2008 at 06:55:26PM +0000, Al Viro wrote:
> > 
> > > It's too ugly for words, but it does deal with this mess ;-/
> > 
> > ... doesn't.  Unfortunately.
> 
> ... since we also need to ifdef out the guts of ftrace_trace_stack().
> We also want to disallow setting TRACE_ITER_STACKTRACE in trace_flags
> on such configs, but that can wait.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

