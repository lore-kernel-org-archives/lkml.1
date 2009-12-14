Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZLNQqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZLNQqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbZLNQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:46:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbZLNQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:46:49 -0500
X-Authority-Analysis: v=1.0 c=1 a=o6lh4s-g2JoA:10 a=7U3hwN5JcxgA:10 a=tNPhcYP9SKbSEg0RVuAA:9 a=uksm0Bz8EQsdXc08Qm1VMRqc834A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: stack tracing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091214162713.GA31060@elte.hu>
References: <20091211184018.738768739@goodmis.org>
	 <20091214161257.GA20097@elte.hu>  <20091214162713.GA31060@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 14 Dec 2009 11:46:46 -0500
Message-ID: <1260809206.2146.416.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 17:27 +0100, Ingo Molnar wrote:
> FYI, i noticed this new warning:
> 
>  kernel/trace/trace.c: In function 'trace_dump_stack':
>  kernel/trace/trace.c:1161: warning: 'return' with a value, in function returning void

Hmm,

I could have sworn I tested for warnings, this must have slipped under
the radar :-/

I'll fix ASAP.

-- Steve


