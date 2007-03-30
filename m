Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXC3JYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXC3JYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXC3JYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:24:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXC3JYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:24:40 -0400
Date: Fri, 30 Mar 2007 11:24:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070330092434.GA20903@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu> <ada4po9mlw5.fsf@cisco.com> <adavegpl0jd.fsf@cisco.com> <20070327192400.GB31695@elte.hu> <ada648mo4md.fsf@cisco.com> <20070330090206.GA14324@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330090206.GA14324@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Great, thanks ... I'm not sure which of the 2 patches fixed things, 
> > but I now got the following trace.  I've not really analyzed this, 
> > but it definitely looks like tun_init() is doing something fishy... 
> > ("149776 us maximum-latency"!!)
> 
> best would be to enable FUNCTION_TRACING and to do:
> 
> 	echo 1 > /proc/sys/kernel/trace_enabled
> 	echo 1 > /proc/sys/kernel/mcount_enabled
> 
> this will give you an exact trace of what happened, in 
> /proc/latency_trace.

btw., if you use -rt, it makes sense to disable the UNWIND options in 
the .config - the unwinder causes quite some overhead at places.

	Ingo
