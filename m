Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZD2NLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZD2NLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZD2NHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:07:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbZD2NHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:07:45 -0400
Date: Wed, 29 Apr 2009 15:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       cl@linux.com, jesse.brandeburg@intel.com, netdev@vger.kernel.org,
       haoki@redhat.com, mchan@broadcom.com, davidel@xmailserver.org
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
Message-ID: <20090429130706.GA22449@elte.hu>
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com> <20090429091637.GA29874@elte.hu> <49F81FB9.50504@cosmosbay.com> <20090429102734.GC2373@elte.hu> <49F84833.5000908@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F84833.5000908@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> > should be inline perhaps?
> 
> Well, I thought current practice was not using inline for such 
> trivial functions, as gcc already inlines them anyway.

ok.

how about:

> > [ I'd still suggest to factor out the guts of do_select() as 
> >   its nesting is excessive that hurts its reviewability quite a 
> >   bit - but now your patch does not make the situation any 
> >   worse. ]

We tend to shop for drive-by cleanups in visibly ugly code whenever 
someone wants to touch that code. Could go into a separate patch.

	Ingo
