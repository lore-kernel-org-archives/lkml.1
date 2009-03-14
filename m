Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZCNNU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZCNNU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZCNNUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:20:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60282 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbZCNNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:20:07 -0400
Date: Sat, 14 Mar 2009 21:19:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: therbert@google.com, yanmin_zhang@linux.intel.com,
       bhutchings@solarflare.com, andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
	submit to upper layer
Message-ID: <20090314131951.GA6080@gondor.apana.org.au>
References: <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com> <20090313.151913.21135937.davem@davemloft.net> <65634d660903131724s49009177pdc11005aa76a4b56@mail.gmail.com> <20090313.191951.228619450.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313.191951.228619450.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 07:19:51PM -0700, David Miller wrote:
> From: Tom Herbert <therbert@google.com>
> Date: Fri, 13 Mar 2009 17:24:10 -0700
> 
> > Enabling HW multi-queue has somewhat higher CPU
> > utilization though, the extra device interrupt load is not coming for
> > free.  We actually use the HW multi-queue in conjunction with our
> > software steering to get maximum pps (about 20% more).
> 
> This is a non-intuitive observation.  Using HW multiqueue should be
> cheaper than doing it in software, right?

Shared caches can play games with the numbers, we need to look
at this a bit more.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
