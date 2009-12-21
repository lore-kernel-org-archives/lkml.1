Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZLUBUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZLUBUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZLUBUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZLUBUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:09 -0500
Subject: Re: sched: restore sanity
From: Joe Perches <joe@perches.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, San Mehat <san@google.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091221014848.7833c875@infradead.org>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
	 <1261329743.30458.179.camel@Joe-Laptop.home>
	 <20091220191725.1799eab7@infradead.org>
	 <1261333310.30458.205.camel@Joe-Laptop.home>
	 <20091221014848.7833c875@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 17:20:08 -0800
Message-ID: <1261358408.30458.242.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 01:48 +0100, Arjan van de Ven wrote:
> but you still have a "multiline message" (the atomic schedule oops like
> dump) that now is half printk half pr_*... where pr_ is just a silly
> wrapper around printk now that the prefixing etc is gone.

Nope.  That's what pr_cont does.

There could be some extension that does a better job
of avoiding multiple process message interleaving.

> > I believe kernel log output is specifically _not_ guaranteed
> > and should not be so guaranteed to remain stable across
> > versions.
> 
> changing it gratuitously is bad though. There *are* scripts out there
> parsing oopses. Yes they change as kernels change, but changing
> the output of oopses for silly reasons is just hostile 

Yup.  sched should have not had pr_fmt defined.
oh well.

