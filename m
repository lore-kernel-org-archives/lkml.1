Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZISP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZISP34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbZISP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:29:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZISP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:29:55 -0400
Subject: Re: [PATCH 3/3] tracing/events: use list_for_entry_continue
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090918150930.GB5200@nowhere>
References: <4AB32364.7020602@cn.fujitsu.com>
	 <4AB32389.1030005@cn.fujitsu.com>  <20090918150930.GB5200@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 19 Sep 2009 11:29:56 -0400
Message-Id: <1253374196.20020.341.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 17:09 +0200, Frederic Weisbecker wrote:
> On Fri, Sep 18, 2009 at 02:07:05PM +0800, Li Zefan wrote:
> > Simplify s_next() and t_next().
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> 
> 
> 
> 
> Nice.
> I wonder if that can be even more simplified with
> the following existing seq helpers:
> 
> extern struct list_head *seq_list_start(struct list_head *head,
> 		loff_t pos);
> extern struct list_head *seq_list_start_head(struct list_head *head,
> 		loff_t pos);
> extern struct list_head *seq_list_next(void *v, struct list_head *head,
> 		loff_t *ppos);

This could be another patch someday.

> 
> 
> That said, it's already a nice cleanup.
> 

I'll take this as an Acked-by then?

-- Steve


