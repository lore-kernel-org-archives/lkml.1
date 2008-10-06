Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJFVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJFVVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYJFVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:21:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:38408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbYJFVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:21:38 -0400
Date: Mon, 6 Oct 2008 14:21:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
Message-ID: <20081006142131.37104893@infradead.org>
In-Reply-To: <20081006211939.GL3180@one.firstfloor.org>
References: <20081006102640.481acd23@infradead.org>
	<87y711moz2.fsf@basil.nowhere.org>
	<20081006135715.6a52e954@infradead.org>
	<20081006211939.GL3180@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > the link between P states and frequency is... rather lose.
> > Especially with Turbo Mode it no longer is really relevant to list
> > frequencies.
> 
> It would probably be less confusing for everyone if the higher level
> cpufreq layers reported the correct frequency for turbo mode too.
> I haven't checked how complicated this would be.

it's impossible until after the fact; you don't know which frequencies
you got until you check back later.


> Ok.
> 
> That means that when a CPU is idle forever there won't be any output?

correct; it'll wait until it stops being idle before telling  you how
long it was idle.

if it really bothers you we could do a dummy broadcast ipi on shutting
down the tracer.. in practice it's not a problem.
(we wake up all cpus all the time)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
