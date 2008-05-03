Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYECD3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYECD3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 23:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbYECD3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 23:29:13 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:35929 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757024AbYECD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 23:29:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=CGnBzhe/XES1GBmqL/NBWYpRNq8hIgfQVvTst3ErdnaW9y9eF6GHXKrx7o8GLdfWCVRthD8stAS/T/N49svtA0VK/Ha7ym7G2ep9jrhKFMsqoVKS0BHuHRpgOt8sG16D2VdCBk2OZi5I+GCWoDPoFhmYGZjAnrh9DxbICfN9bDY=  ;
X-YMail-OSG: ztTjME0VM1nF7_.z3W58EJPHt2JqrH.0x_CMexaJbXjivhswSwMPGQIItLVkVTVuDc8c2041cCvUeUTjdJ0Mod4wwYGK7tD816ED9nRBGTd6dHureROxO_GaQ9D3upO5eaM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Fri, 2 May 2008 19:58:04 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804302135.56529.david-b@pacbell.net> <Pine.LNX.4.64.0805011249500.18441@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0805011249500.18441@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805021958.04758.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008, Trent Piepho wrote:
> >> 	IMHO, if you can't do this simple task in 5 minutes
> >> with just busybox, the system is making things too hard.
> >
> > Right, and since I *can* do stuff like that in busybox with ASH,
> > that quickly, I hope you'll agree your flamage has been blowing
> > things way out of proportion here.
> 
> It's so easy, yet no one posts the code to do it.

I think that's because it's a trivial "Shell Programming 101"
homework assignment, and we have a general policy against doing
people's schoolwork for them ...

Here are two clues for you:  "for DIR in gpiochip*"; and then
"LABEL=$(cat $DIR/label)".  I'm quite certain that if you put
aside your demonstrably strong desire to flame, you can solve
that little problem.

Or perhaps the issue here is just bikeshedding.  Regardless,
the signal-to-noise ratio is way too low..
