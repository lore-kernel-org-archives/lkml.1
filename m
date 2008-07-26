Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYGZQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYGZQJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYGZQJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:09:06 -0400
Received: from stinky.trash.net ([213.144.137.162]:34297 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYGZQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:09:05 -0400
Message-ID: <488B4C1D.3020506@trash.net>
Date: Sat, 26 Jul 2008 18:09:01 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
 pointer dereference
References: <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu> <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net> <84144f020807240544q507e1b7cv220d1afbae0ee0f0@mail.gmail.com> <48887A71.5010209@trash.net> <1216905812.5897.6.camel@penberg-laptop> <48888434.3030207@trash.net> <1216906476.12021.4.camel@penberg-laptop> <20080724115127.6cfbb616.akpm@linux-foundation.org> <20080724193532.GC1694@elte.hu>
In-Reply-To: <20080724193532.GC1694@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> Ingo, did this patch actually fix something over there?
> 
> not that i know of. I'll do some re-tests tomorrow to make sure.

I managed to reproduce the bug you reported, but it reliably
goes away if I add Pekka's patch. Did you get a chance to
retest already?


