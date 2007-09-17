Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXIQNQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXIQNQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXIQNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:16:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37751 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXIQNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YY3bTUIu+nm7gEyxRGILgLNRqcwS/34LsfoQFBOD96tL/UpwzA1+pr1HImkYMHTzUwLIFsQSE5gtrAFwH8qb88RrnAUdY66NEotYMTPp6VVxdbM+s9ddN8v6eqY8FYwPorJmdGW/5C3OnJjxeTxOhDFpSgdZMzhP2rrYD3BStqE=
Subject: Re: 2.6.22.1: Enabling IO-APIC = APIC error on CPU0: 40(40)
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Reply-To: konstantin.sharlaimov@gmail.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709170909520.8681@p34.internal.lan>
References: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>
	 <1190034476.8152.8.camel@traveler>
	 <Pine.LNX.4.64.0709170909520.8681@p34.internal.lan>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 00:16:31 +1100
Message-Id: <1190034991.8152.14.camel@traveler>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree, this is probably somehow related with SiS chipset - my laptop
has one of these SiS 760 host controllers inside. 

I'll probably do some digging to figure out if this is indeed chipset
related. I wonder if this error occurs under Windows (Win does not
report much, yet it's kernel must be aware of such error).

Konstantin

On Mon, 2007-09-17 at 09:10 -0400, Justin Piszcz wrote:
> 
> On Tue, 18 Sep 2007, Konstantin Sharlaimov wrote:
> 
> > I am experiencing the similar problem on my Acer Aspire 5000 laptop -
> > once in a while a bunch of "APIC error on CPU0: 40(40)" messages are
> > showing up in dmesg.
> >
> > After few experiments and a lot of googling, I identified a cause - it
> > was my built-in wireless card! Disabling IO-APIC helped, besides a
> > single "Spurious 8259A interrupt: IRQ7" message while booting up there
> > was nothing unusual.
> >
> > A did some further experiments on various hardware and from my
> > experience I can tell that "APIC error" messages are entirely hardware
> > related.
> >
> > Regards,
> > Konstantin
> 
> Thanks for the follow-up, yeah its probably one of the Promise
> controllers or some such that is causing the problem, although I
> remmeber I used to get the error with only the motherboard, memory and
> video card, something tells me that MSI board with (SiS) chipset is
> not quite supported in Linux with APIC enabled.
> 
> Justin.
> 
> 

