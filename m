Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYGZNp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYGZNp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbYGZNnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:43:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:64043 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYGZNnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:43:51 -0400
Message-ID: <488B2A11.9090606@trash.net>
Date: Sat, 26 Jul 2008 15:43:45 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
 pointer dereference
References: <20080724060448.GA10203@elte.hu>	<E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>	<20080724.022259.113079007.davem@davemloft.net>	<20080724093411.GA12001@elte.hu>	<20080724115625.GA23994@elte.hu>	<20080724115957.GA25701@elte.hu>	<48886FA6.6050908@trash.net>	<84144f020807240544q507e1b7cv220d1afbae0ee0f0@mail.gmail.com>	<48887A71.5010209@trash.net>	<1216905812.5897.6.camel@penberg-laptop>	<48888434.3030207@trash.net>	<1216906476.12021.4.camel@penberg-laptop> <20080724115127.6cfbb616.akpm@linux-foundation.org>
In-Reply-To: <20080724115127.6cfbb616.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 24 Jul 2008 16:34:36 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>>>> [PATCH] netfilter: fix double-free and use-after free
>>>>
>> Ingo, can you please test this? Andrew, I'm at OLS so can you pick up
>> the patch in your tree?
> 
> Sure.  Or Patrick can do so and it can be merged via the net tree.

I've picked it up and will merge it via Dave.
