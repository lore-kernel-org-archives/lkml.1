Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbXIQNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbXIQNLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXIQNKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:10:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:50089 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXIQNKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:10:50 -0400
Date: Mon, 17 Sep 2007 09:10:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.1: Enabling IO-APIC = APIC error on CPU0: 40(40)
In-Reply-To: <1190034476.8152.8.camel@traveler>
Message-ID: <Pine.LNX.4.64.0709170909520.8681@p34.internal.lan>
References: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>
 <1190034476.8152.8.camel@traveler>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Konstantin Sharlaimov wrote:

> I am experiencing the similar problem on my Acer Aspire 5000 laptop -
> once in a while a bunch of "APIC error on CPU0: 40(40)" messages are
> showing up in dmesg.
>
> After few experiments and a lot of googling, I identified a cause - it
> was my built-in wireless card! Disabling IO-APIC helped, besides a
> single "Spurious 8259A interrupt: IRQ7" message while booting up there
> was nothing unusual.
>
> A did some further experiments on various hardware and from my
> experience I can tell that "APIC error" messages are entirely hardware
> related.
>
> Regards,
> Konstantin

Thanks for the follow-up, yeah its probably one of the Promise
controllers or some such that is causing the problem, although I
remmeber I used to get the error with only the motherboard, memory and
video card, something tells me that MSI board with (SiS) chipset is
not quite supported in Linux with APIC enabled.

Justin.


