Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZGBUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZGBUKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZGBUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:05:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbZGBUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:05:35 -0400
Date: Thu, 2 Jul 2009 22:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: [GIT]: Networking
Message-ID: <20090702200526.GA2969@elte.hu>
References: <20090630.213927.180401151.davem@davemloft.net> <20090702075724.GA10608@elte.hu> <4A4C9125.8020705@gmail.com> <4A4CBE7D.2060603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4CBE7D.2060603@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0115]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> We might have a race in napi_schedule(), leaving interrupts 
> disabled forever. I cannot test this patch, I dont have the 
> hardware...

I have tested it and the config that failed before works now. (as do 
other configs as well)

I'll have to re-test whether the failing config fails with your fix 
reverted - that will have to wait until tomorrow or so.

	Ingo
