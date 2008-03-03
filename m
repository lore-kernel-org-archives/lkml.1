Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbYCCKq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbYCCKq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYCCKqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:46:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYCCKqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:46:21 -0500
Date: Mon, 3 Mar 2008 11:45:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Message-ID: <20080303104559.GE21190@elte.hu>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com> <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu> <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com> <20080229194547.GC21249@elte.hu> <f19298770802291642v56a8a50ve5c7c88de53513f4@mail.gmail.com> <f19298770802291659x741c9fd9h3b3090fd514fe77b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770802291659x741c9fd9h3b3090fd514fe77b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> >  I"ll now recompile with fair group scheduler disabled, just to be 
> >  sure.
> 
> Yes, with the group scheduler disabled, the latencies for both Xorg 
> and gnome-terminal do net exceed 15 ms. And the mouse is also smooth.

could you also try the current scheduler fixes lineup in 
sched-devel.git:

   http://people.redhat.com/mingo/sched-devel.git/README

is the mouse smooth with the group scheduler _enabled_ too?

	Ingo
