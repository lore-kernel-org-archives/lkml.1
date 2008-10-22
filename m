Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYJVUFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYJVUFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYJVUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:05:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35716 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYJVUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:05:44 -0400
Subject: Re: sched: deep power-saving states
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20081022125508.2ccea6e1@infradead.org>
References: <48FF2DDC.5010600@gmail.com>
	 <20081022064738.05818670@infradead.org> <48FF3321.4060809@novell.com>
	 <20081022070701.567f1c9a@infradead.org> <48FF3829.8040704@novell.com>
	 <20081022073616.5eb150fa@infradead.org> <1224704992.20069.71.camel@twins>
	 <20081022125508.2ccea6e1@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Oct 2008 22:05:25 +0200
Message-Id: <1224705925.20069.76.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 12:55 -0700, Arjan van de Ven wrote:
> On Wed, 22 Oct 2008 21:49:52 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > This still leaves us with the worst case IRQ response as given by the
> > deepest C state. Which might be un-desirable.
> 
> that's a different problem in a different problem space.

Ah right, so the only point was trying to wake shallow cpus so as to try
and let deep cpus idle longer?

> > jcm was, once upon a time, working on dynamically changing the idle
> > routine, so that people who care about wakeup latency can run
> > idle=poll while their application runs, and the acpi C state stuff
> > when nobody cares.
> > 
> > This could of course then be tied into the PM QoS stuff Mark has been
> > doing.
> 
> in fact you already have this *exactly* today; this isn't future
> technology.

Interesting, what knob do I turn to get idle=poll dynamically?
