Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZCMX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZCMX6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZCMX6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:58:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56636 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751659AbZCMX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:58:33 -0400
Date: Sat, 14 Mar 2009 07:58:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: therbert@google.com, yanmin_zhang@linux.intel.com,
       bhutchings@solarflare.com, andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
	submit to upper layer
Message-ID: <20090313235815.GA2713@gondor.apana.org.au>
References: <65634d660903131358h765bef64y6a0f1b0db7400f6f@mail.gmail.com> <20090313.140217.143696945.davem@davemloft.net> <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com> <20090313.151913.21135937.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313.151913.21135937.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 03:19:13PM -0700, David Miller wrote:
> 
> > improvement in packets per second across both our dumb 1G and 10G
> > NICs
> 
> Do these NICs at least support multiqueue?

I don't think they do.  See the lsat paragraph in Tom's first
email.

I think we all agree that hacks such as these are onlhy useful
for NICs that either don't support mq or if the number of rx
queues is too small.

The question is how much do we love these NICs :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
