Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbYLXDgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbYLXDgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLXDgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:36:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40073 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYLXDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:36:42 -0500
Date: Tue, 23 Dec 2008 22:36:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: enable format arguments checking
In-Reply-To: <4951AB76.3030709@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0812232233460.21172@gandalf.stny.rr.com>
References: <494CB7A2.1070603@cn.fujitsu.com> <4951AB76.3030709@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Dec 2008, Lai Jiangshan wrote:

> Lai Jiangshan wrote:
> > format arguments checking for ftrace_printk() is __printf(1, 2),
> > not __printf(1, 0).
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 9c5bc6b..0c71788 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -210,7 +210,7 @@ extern void ftrace_dump(void);
> >  static inline void
> >  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
> >  static inline int
> > -ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
> 
> Hi, Steven Rostedt
> 	Did you notice this patch?
> 	This patch changed a char in a line: s/0/2/. It enables the format checking.
> 
> 	Lai.
> 
> > +ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
> >  
> >  static inline int
> >  ftrace_printk(const char *fmt, ...)
> > 

Ah yes, sorry, I'm rushing to get some other things done because I'll be 
on holiday tomorrow through to Jan 5th.

I'll pull it into the rest of my next series.

-- Steve

