Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYLSVl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYLSVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYLSVkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:40:37 -0500
Received: from www.tglx.de ([62.245.132.106]:55965 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbYLSVkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:40:35 -0500
Date: Fri, 19 Dec 2008 22:40:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: Re: [patch 1/7] ftrace: fix task state printout
In-Reply-To: <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812192239280.3376@localhost.localdomain>
References: <20081219155504.735865178@linutronix.de>  <20081219155555.919550408@linutronix.de> <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-472957789-1229722822=:3376"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-472957789-1229722822=:3376
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 19 Dec 2008, Frédéric Weisbecker wrote:
> Hi Thomas,
> 
> 2008/12/19 Thomas Gleixner <tglx@linutronix.de>:
> > Impact: tracer task state decoding is wrong, size check is buggy
> >
> > The tracing code has interesting varieties of printing out task state.
> > Unfortunalely only one of the instances is correct as it copies the
> > code from sched.c:sched_show_task(). The others are plain wrong as
> > they treatthe bitfield as an integer offset into the character
> > array. Also the size check of the character array is wrong as it
> > includes the trailing \0.
> >
> > Use a common state decoder inline which does the Right Thing.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> 
> You've already sent it out. It has been applied on -tip :-)

Yep, but these patches are against 2.6.24.7-rt24 as noted in the
subject line of patch 0/7 :)

Thanks,

	tglx

--8323328-472957789-1229722822=:3376--
