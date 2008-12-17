Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752971AbYLQW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbYLQW3e (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYLQW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:29:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLQW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:29:20 -0500
Date: Wed, 17 Dec 2008 17:29:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: trace: fix task state printout
In-Reply-To: <alpine.LFD.2.00.0812172229490.3492@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0812171727160.4839@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0812172229490.3492@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 17 Dec 2008, Thomas Gleixner wrote:

> Impact: tracer task state decoding is wrong, size check is buggy

The Imact line seems more of a subject line. The real Impact line should 
be something like:

Impact: fix wrong decoding of task state int tracer

Keyword is 'fix'

> 
> The tracing code has interesting varieties of printing out task state.
> Unfortunalely only one of the instances is correct as it copies the
> code from sched.c:sched_show_task(). The others are plain wrong as
> they treatthe bitfield as an integer offset into the character
> array. Also the size check of the character array is wrong as it
> includes the trailing \0.
> 
> Use a common state decoder inline which does the Right Thing.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Steven Rostedt <srostedt@redhat.com>


Ingo, this is a low risk fix that probably should be pushed towards Linus 
for inclusion into 2.6.28.

-- Steve

