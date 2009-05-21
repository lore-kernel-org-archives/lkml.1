Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZEUMma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZEUMma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 08:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZEUMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 08:42:23 -0400
Received: from ozlabs.org ([203.10.76.45]:44059 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZEUMmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 08:42:22 -0400
Date: Thu, 21 May 2009 22:38:10 +1000
From: Anton Blanchard <anton@samba.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
	tracepoints
Message-ID: <20090521123810.GB23442@kryten>
References: <20090520101334.GA23442@kryten> <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Frédéric,

> > +       ),
> > +
> > +       TP_fast_assign(
> > +               __entry->function = timer->function;
> > +       ),
> > +
> > +       TP_printk("func=%pF", __entry->function)
> 
> 
> Please use %pf which only prints the function name and ignore the
> offsets and so... These overload
> the trace in such case.

Thanks for the suggestion. It doesn't look like %pf has made Ingo's tree
yet, do you know if there is a plan to merge it soon?

Anton
