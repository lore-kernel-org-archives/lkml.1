Return-Path: <linux-kernel-owner+w=401wt.eu-S1751058AbXCJSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbXCJSVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 13:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXCJSVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 13:21:31 -0500
Received: from rtr.ca ([64.26.128.89]:1028 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXCJSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 13:21:30 -0500
Message-ID: <45F2F727.7010406@rtr.ca>
Date: Sat, 10 Mar 2007 13:21:27 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
References: <20070309053931.GA10459@waste.org> <87irdasnz4.fsf@depni.sinp.msu.ru> <45F1A263.5020407@rtr.ca> <200703100723.51858.kernel@kolivas.org>
In-Reply-To: <200703100723.51858.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Saturday 10 March 2007 05:07, Mark Lord wrote:
>> Mmm.. when it's good, it's *really* good.
>> My desktop feels snappier and all of that.
>..
>> But when it's bad, it stinks.
>> Like when a "make -j2" kernel rebuild is happening in a background window
> 
> And that's bad. When you say "it stinks" is it more than 3 times slower? It 
> should be precisely 3 times slower under that load (although low cpu using 
> things like audio wont be affected by running 3 times slower). If it feels 
> like much more than that much slower, there is a bug there somewhere.

Scrolling windows is incredibly jerkey, and very very sluggish
when images are involved (eg. a large web page in firefox).

> As another reader suggested, how does it run with the compile 'niced'? How does 
> it perform with make (without a -j number).

Yes, it behaves itself when the "make -j2" is nice'd.

>> This is on a Pentium-M 760 single-core, w/2GB SDRAM (notebook).
> 
> What HZ are you running? Are you running a Beryl desktop?

HZ==1000, NO_HZ, Kubunutu Dapper Drake distro, ATI X300 open-source X.org driver.

Cheers
