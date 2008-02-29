Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbYB2OcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbYB2OcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbYB2Ob7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:31:59 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:53219 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912AbYB2Ob6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:31:58 -0500
Date: Fri, 29 Feb 2008 15:31:52 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <Pine.LNX.4.58.0802290852060.8804@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0802291528071.2723@scrub.home>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <Pine.LNX.4.58.0802290852060.8804@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Feb 2008, Steven Rostedt wrote:

> > Also why is this a choice? Are more RCU types planned?
> 
> Why shouldn't it be a choice? You can have CLASSIC_RCU or PREEMPT_RCU, one
> or the other and not both. Sounds perfect for being a choice.

With this logic almost every bool could be implemented via choice.
A simple bool perfectly gives you two choices too.

bye, Roman
