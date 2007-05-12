Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXELGVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXELGVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXELGVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:21:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbXELGVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:21:39 -0400
Message-ID: <46455CD9.7010205@zytor.com>
Date: Fri, 11 May 2007 23:21:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com> <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>
In-Reply-To: <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> 
> Because volatile is ill-defined? Or actually, *undefined* (well,
> implementation-defined is as good as that)? It's *so* _vague_,
> one doesn't _feel_ like using it at all!
> 

Sorry, that's just utter crap.  Linux isn't written in some mythical C
which only exists in standard document, it is written in a particular
subset of GNU C.  "volatile" is well enough defined in that context, it
is just frequently misused.

> We already have a complete API containing optimization barriers,
> load/store/full memory barriers. With well-defined and
> well-understood semantics. Just ... _why_ use volatile?

See below.

> It will _always_ work. In fact you can't really say the same for
> volatile. We already assume the compiler _actually_ took some
> pains to stuff meaning into C's (lack of) definition of volatile and
> implement it -- but in what sense, nobody knows (the C standard
> doesn't, so what are we).

It will always work within the context of GNU C.

>> more heavy-handed as it's disabling *all* optimization such as loop
>> invariants across the barrier.
> 
> This is a legitimate criticism, I agree.

There you have it.

	-hpa
