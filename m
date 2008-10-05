Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYJELuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYJELuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYJELuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:50:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58416 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752920AbYJELuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:50:03 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: rjw@sisk.pl (Rafael J. Wysocki)
Subject: Re: 2.6.27-rc8-git7: Reported regressions from 2.6.26
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       protasnb@gmail.com, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, cl@linux-foundation.org
Organization: Core
In-Reply-To: <200810051302.20896.rjw@sisk.pl>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KmS79-0003mo-5j@gondolin.me.apana.org.au>
Date: Sun, 05 Oct 2008 19:49:31 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=11308
>> > Subject             : tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
>> > Submitter   : Christoph Lameter <cl@linux-foundation.org>
>> > Date                : 2008-08-11 18:36 (55 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=121847986119495&w=4
>> >               http://marc.info/?l=linux-kernel&m=122125737421332&w=4
>> 
>> Just for the reference, this one regresses from the 2.6.23.
> 
> Still, tbench results from 2.6.26 are better than from 2.6.27-rc.
> That's why it's still on the list, but if you think that's not relevant, please
> let me know and I'll drop it.

Note that 2.6.27 beats 2.6.26 by 30% with bulk traffic over
loopback as opposed to the small packets sent by tbench where
I saw a 5% drop in performance on my machine.

So I'm not sure whether this should really be classified as
a regression if we limit ourselves to the changes between 26
and 27.

The changes prior to 26 seem to be more significant.

Chyeers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
