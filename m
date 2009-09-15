Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbZIOENK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbZIOENK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZIOENI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:13:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:48609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZIOENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:13:06 -0400
Date: Tue, 15 Sep 2009 06:16:45 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: Re: [PATCH 5/8] trace: Convert the power tracer into an event
 tracer
Message-ID: <20090915061645.0375ef60@infradead.org>
In-Reply-To: <4AAF0D54.2040506@cn.fujitsu.com>
References: <20090912130306.5d0086ea@infradead.org>
	<20090912130542.6d314860@infradead.org>
	<4AAF0D54.2040506@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 11:43:16 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Arjan van de Ven wrote:
> >>From f591a0f126263733d606838a5d113b9807b12c84 Mon Sep 17 00:00:00
> >>2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sat, 12 Sep 2009 07:53:03 +0200
> > Subject: [PATCH] trace: Convert the power tracer into an event
> > tracer
> > 
> > This patch converts the existing power tracer into an event tracer,
> > so that power events (C states and frequency changes) can be tracked
> > via "perf".
> > 
> > This also removes the perl script that was used to demo the tracer;
> > its functionality is being replaced entirely with timechart.
> > 
> 
> And Documentation/power.txt needs update, or just remove it?

remove it; will do
> 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> ...
> 
> > diff --git a/kernel/trace/power-traces.c
> > b/kernel/trace/power-traces.c new file mode 100644
> > index 0000000..cb4fc51
> > --- /dev/null
> > +++ b/kernel/trace/power-traces.c
> 
> This file is not necessarily needed.
> 
> You can just add definition of CREATE_TRACE_POINTS in process.c.

hmm it seems existing style to do this in kernel/trace/ though

> > +
> > +EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
> > +
> 
> I think it's power_frequency that needs to be exported?

very valid point, will fix.

thank you for reviewing the patch; I will send an updated patch out
asap.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
