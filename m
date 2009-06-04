Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbZFDIxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbZFDIxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbZFDIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:52:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26267 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbZFDIwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RtRrDh+fil4WggpiyBCx+zopwLjEs2yuLHHE61n2js3tN3dlz8nWp49KYurBY561QY
         u5RTVkM4DIR5NG/ivV3kAlTG9q0mq5xQ7mV/FnYaEahkDG0TPUQ+W6jJiwrceQOWvGBY
         CoFe8aUd1CVhTfRZHzMf/pUlUY6rTdlXBgp3A=
MIME-Version: 1.0
In-Reply-To: <200906040127.24740.david-b@pacbell.net>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	 <20090604005435.d3671419.akpm@linux-foundation.org>
	 <8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
	 <200906040127.24740.david-b@pacbell.net>
Date: Thu, 4 Jun 2009 04:52:35 -0400
Message-ID: <8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
From: Mike Frysinger <vapier.adi@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 04:27, David Brownell wrote:
> On Thursday 04 June 2009, Mike Frysinger wrote:
>> > A suitable place to document this is Documentation/gpio.txt.
>>
>> yes, but i wanted to make sure David didnt reject the idea before i
>> spend time writing documentation.
>
> My initial reaction was that the function is somewhat superfluous,
> so having a use case in the patch comment would be good:  why
> can't userspace do the toggle itself?

when people were using the simple-gpio driver i wrote (which had
pretty much function parity with the sysfs implementation), i had a
customer or two ask for toggle for their systems.  i didnt get details
for why they wanted a toggle however ... they wanted it in their app
and adding it was trivial.

> On the other hand, I find it hard to object to such a small feature.
> If that's the worst feature bloat in Linux this year, we're overdue
> for a big party.  ;)

my next request was for a 1 letter command set and chaining
operations.  say you want to toggle a gpio line 4 times, having to go
between kernel and userspace for that seems kind of heavy.
echo TTTT > value
-mike
