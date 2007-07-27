Return-Path: <linux-kernel-owner+w=401wt.eu-S938204AbXG0WUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938204AbXG0WUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937439AbXG0WUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:20:25 -0400
Received: from neon.samage.net ([85.17.153.66]:46294 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937254AbXG0WUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:20:24 -0400
Message-ID: <33456.81.207.0.53.1185574821.squirrel@secure.samage.net>
In-Reply-To: <1185573974.2711.8.camel@laptopd505.fenrus.org>
References: <200707272243.02336.a1426z@gawab.com>
    <1185568498.2711.5.camel@laptopd505.fenrus.org>
    <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
    <1185573974.2711.8.camel@laptopd505.fenrus.org>
Date: Sat, 28 Jul 2007 00:20:21 +0200 (CEST)
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources 
      (was: updatedb)
From: "Indan Zupancic" <indan@nul.nu>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Al Boldi" <a1426z@gawab.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 71684ae416b12bc74806129cb02de027
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, July 28, 2007 00:06, Arjan van de Ven wrote:
> On Fri, 2007-07-27 at 23:51 +0200, Indan Zupanci
>> > also, they take up seek time (5 to 10 msec), so if you were to read
>> > something else at the time you get additional latency.
>>
>> If there's other disk activity swap prefetch shouldn't do much, so this isn't
>> really true.
>
> how do you know there will be other activity? You start the IO and that
> basically blacks out the disk for 5 to 10 ms. If the "real" IO gets
> submitted in that time you add latency. You cannot predict that IO
> happening or not happening.

Ah, in that way. Yes, you right about that (though NCQ might help then?),
but that's true for all disk activity. Though I think swap prefetch didn't want
to run when there was CPU activity, so that would reduce the chance that
new IO is submitted right at that moment. I think in practice this isn't worth
worrying about, the real issue is the extra disk activity in the first place.

Greetings,

Indan


