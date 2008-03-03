Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbYCCTHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbYCCTHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYCCTHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:07:40 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:42056 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754664AbYCCTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:07:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sdEidblnmVGGl90TwA9zHvxaGCmqwiM07FQrrvwuoVx/Xa03AJXeiSoVul/6K+90zOJEvhzHtrr/nkkOwoHm9NwWHa6+Rq85QqlJ8q7DriarfZf5HPcsup8Hk9N2ja48ZQEbLzNoeBhKCz9REXpGsXCxJvvkxz4Q0WREb9X5svE=  ;
X-YMail-OSG: tKJ2ID8VM1mD35dhUmbxpY1t5hrPqOv3PEbcQIoA3CzSwELK2vuUx8R6XKxR8tEsMPbrU70Uhg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "mahendra varman" <mahendravarman15@gmail.com>
Subject: Re: usb detecting only high speed devices only - not detecting low speed devices
Date: Mon, 3 Mar 2008 11:07:36 -0800
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <4ac2955e0802260543n7d7e5d81nb590d2bc10648269@mail.gmail.com> <200802261817.02830.david-b@pacbell.net> <4ac2955e0803030131t72354cecpbdaf53460ef3d09f@mail.gmail.com>
In-Reply-To: <4ac2955e0803030131t72354cecpbdaf53460ef3d09f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031107.36500.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, mahendra varman wrote:
> >
> >  Now as to *why* that happens, I don't know.  We've certainly had folk
> >  using Philips/NXP EHCI controllers successfully before.  Maybe this
> >  board has a hardware problem, like a bad chip or not having wired
> >  up the power lines that OHCI controller uses.
> 
> still the low speed devices are giving unlink after no IRQ.. 

Not at all surprising if you haven't changed anything.

You *did* verify this happens on all the ports of that chip?


> My 
> hardware engineer says he followed the reference schematics of ISP1562
> of philips. He says that ohci side, the power lines are wired up
> 
> My Ehci devices can be mounted and the files are read
> Today I faced another issue
> For some usb ehci devices its giving "device descriptor read/64, error
> -71" ( for some usb stick of usb2.0)
> but for others i can able to mount without this error.....
> 
> Sir, Any clue regarding the above problem iam facing currently ??

I gave you all the clues I've got.  You're the one with the
uniquely mis-behaving hardware...

Time for you to work harder at debugging your problem.  You
have the hardware, the software source code, a cooperative
hardware engineer ... that's a lot more than most folk have
when they start to chase down problems like this.

- Dave

