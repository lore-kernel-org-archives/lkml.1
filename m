Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLOIDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLOIDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYLOIDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:03:24 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:29654 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbYLOIDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:03:23 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt
 triggering on output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081213074930.GA4205@elte.hu>
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com>
	 <20081212101448.GE18152@elte.hu>
	 <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
	 <20081213074930.GA4205@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Dec 2008 09:03:21 +0100
Message-Id: <1229328201.14605.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 08:49 +0100, Ingo Molnar wrote:
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > applied to tip/tracing/function-graph-tracer, thanks Frederic!
> > >
> > > The output looks really nice.
> > >
> > >        Ingo
> > >
> > 
> > Thanks :-)
> > 
> > If anyone  has other needs or suggestions about this tracer, don't
> > hesitate to request it.
> > I remember Peter suggested that the preempt count could be output.
> 
> that reminds me ... did you know about hardirq_count()? We could use it 
> to detect IRQ entries in a more generic way, instead of the section 
> trick?

hardirq_count() is set from __irq_enter(), which is too late, we've
already had all the ARCH irq code before that.



