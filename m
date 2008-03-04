Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYCDMow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYCDMow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYCDMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:44:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49764 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbYCDMon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:44:43 -0500
Date: Tue, 4 Mar 2008 13:44:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Message-ID: <20080304124427.GE29777@elte.hu>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com> <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu> <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com> <20080229194547.GC21249@elte.hu> <f19298770802291642v56a8a50ve5c7c88de53513f4@mail.gmail.com> <f19298770802291659x741c9fd9h3b3090fd514fe77b@mail.gmail.com> <20080303104559.GE21190@elte.hu> <f19298770803031416y32dbb7dakfc88b8572c2c10fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770803031416y32dbb7dakfc88b8572c2c10fe@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Mon, Mar 3, 2008 at 1:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> >
> >
> > > >  I"ll now recompile with fair group scheduler disabled, just to be
> >  > >  sure.
> >  >
> >  > Yes, with the group scheduler disabled, the latencies for both Xorg
> >  > and gnome-terminal do net exceed 15 ms. And the mouse is also smooth.
> >
> >  could you also try the current scheduler fixes lineup in
> >  sched-devel.git:
> >
> >    http://people.redhat.com/mingo/sched-devel.git/README
> >
> >  is the mouse smooth with the group scheduler _enabled_ too?
> >
> 
> Works fine. The latencies of both Xorg and gnome-terminal are reported 
> to be about 5-20 ms, and the mouse is smooth too.

great - if you dont mind i'll add your:

  Tested-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>

	Ingo
