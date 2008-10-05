Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYJEMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYJEMGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYJEMGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:06:43 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:43380 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYJEMGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:06:42 -0400
Date: Sun, 5 Oct 2008 16:05:11 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       protasnb@gmail.com, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, cl@linux-foundation.org
Subject: Re: 2.6.27-rc8-git7: Reported regressions from 2.6.26
Message-ID: <20081005120511.GA27993@2ka.mipt.ru>
References: <200810051302.20896.rjw@sisk.pl> <E1KmS79-0003mo-5j@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KmS79-0003mo-5j@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Oct 05, 2008 at 07:49:31PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Note that 2.6.27 beats 2.6.26 by 30% with bulk traffic over
> loopback as opposed to the small packets sent by tbench where
> I saw a 5% drop in performance on my machine.
> 
> So I'm not sure whether this should really be classified as
> a regression if we limit ourselves to the changes between 26
> and 27.
> 
> The changes prior to 26 seem to be more significant.

Yes, that's the point, TSO over loopback for big packets or workload
where there packets can be easily combined into big one results in a
fair performance improvement, but for small packets it regresses about
5-10 %. And yes, there are yet unresolved changes which caused bigger
performance degradation.

-- 
	Evgeniy Polyakov
