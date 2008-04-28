Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYD1Mkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYD1Mkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765110AbYD1Mkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:40:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51139 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764572AbYD1Mkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:40:40 -0400
Date: Mon, 28 Apr 2008 16:40:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: get_online_cpus() && workqueues
Message-ID: <20080428124049.GA6263@tv-sign.ru>
References: <20080424150714.GA8273@osiris.boeblingen.de.ibm.com> <1209052984.7115.369.camel@twins> <20080424155946.GA11160@tv-sign.ru> <20080424194810.GA4821@osiris.boeblingen.de.ibm.com> <20080424192706.GA165@tv-sign.ru> <20080425064044.GA10817@osiris.boeblingen.de.ibm.com> <20080426144330.GA6150@tv-sign.ru> <20080428070256.GB14285@in.ibm.com> <20080428105649.GE143@tv-sign.ru> <20080428120343.GD23162@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428120343.GD23162@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Gautham R Shenoy wrote:
>
> On Mon, Apr 28, 2008 at 02:56:49PM +0400, Oleg Nesterov wrote:
> >
> > Yes, possible, but it is not nice that work->func() can't just use
> > get_online_cpus()...
> 
> Like I said, it depends on what they want to use it for. If it is just
> protection against the changing of the cpu_online_map then, it's simple
> as using get_online_map(), i.e the patch you provided.
> 
> BTW, the other thing I am concerned about is the
> naming. Dont the names get_online_cpus() and get_online_map()
> appear very similar. The last thing we want is driver writers getting
> confused over what API to use!

Yes, yes, please forget this patch. I don't like 2 very similar nested
locks, this was a bad idea. I am talking about another (uncompiled)
patch I sent.

> > What do you think about another patch I sent? I am not happy with it,
> > and it certainly uglifies cpu.c, but it is simple...
>
> I am currently testing out the patchstack sent
> by peterz. Once that's done I will see if I can integrate this patch
> with the previous patches and repost the whole series.

OK.

Oleg.

