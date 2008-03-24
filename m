Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYCXIJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYCXIJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYCXIJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:09:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:48642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYCXIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rpeqYaQ4WL4nGW2ebCCglEYms9EY1pVMZFb8cJBO+1kogpYOTvsg+XQTwCZBAlTlNK0N4ocWXwRyv1xA05O1NG6UmUw6hBS+L/c1Imz0PJjgy2cFG5ar/taBl3YHqhXjIXvuAAn4Hw5zo2hh3dspM75VHXt2WUEZcO615cnmWbU=
Message-ID: <47E7619C.6050402@gmail.com>
Date: Mon, 24 Mar 2008 09:09:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Miller <davem@davemloft.net>, viro@ZenIV.linux.org.uk,
       joe@perches.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch [was: include/asm-x86/serial.h: checkpatch cleanups
 - formatting only]
References: <47E647AC.1060906@gmail.com>	<20080323.051929.267232495.davem@davemloft.net>	<47E64BF7.4070808@gmail.com>	<20080323.053037.144236584.davem@davemloft.net>	<47E651BE.1080107@gmail.com> <877ift8hre.fsf@basil.nowhere.org>
In-Reply-To: <877ift8hre.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2008 06:36 PM, Andi Kleen wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
>> It just spits out warnings/errors like compiler or some static
>> analyzer, maybe I'm terribly missing something, what exactly do you
>> mind on the output?
> 
> A good example are the trailing white space warnings in there. They
> are just useless and a waste of time. That is something that really
> should just be done automatically by maintainer scripts somewhere on
> merge (and a lot of maintainers do it automatically), not waste the
> valuable time of a human.

Agreed.

> There are also a couple of other pointless warnings. e.g. I dislike
> some of the style warnings -- they are far too broad. Or there 
> can be good reasons to violate them occasionally. e.g. I would
> rather put not a space around an operator occasionally instead
> of splitting an expression to avoid going over 80 characers. 

Me too, there will ever be certain circumstances where the rules just doesn't
apply and you can't teach the scripts in that way (turning off doubtful warnings
sounds reasonable anyway).

> Or the EXPORT_SYMBOL warning. WTF is that good for? Or 
> the warning about if () ... else { ... }.

Understand you points, but most of it is strict implementation of CodingStyle. 
People, who don't prefer coding style as described in that document, won't like 
checkpatch either.

> Also checkpatch.pl --file seems to be a good candidate for one
> of the worst ideas ever merged (to be fair it was difficult
> to see it would become that bad in advance -- but it got) 

Definitely agree.
