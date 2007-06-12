Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXFLMFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXFLMFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbXFLME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:04:58 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21420 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbXFLME5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:04:57 -0400
Message-ID: <466E8BE5.3030903@msgid.tls.msk.ru>
Date: Tue, 12 Jun 2007 16:04:53 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru> <20070612114345.07ab60f6@the-village.bc.nu>
In-Reply-To: <20070612114345.07ab60f6@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 12 Jun 2007 13:21:43 +0400
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>> I bought a VIA PC2500 board a few days ago - this
>> new series of their mobos,
>>
>> This beast looks nice - after replacing their cooling
>> system (that had a small fan on it) with larger but
>> fanless, -- it becomes a almost real PC (1500MHz CPU),
>> equipped with quite nice crypto and multimedia abilities,
>> but with very low power consumption and very quiet.
>>
>> But the thing is - it doesn't quite work.
> 
> That is usually memory or motherboard timings. memtest86+ will miss a lot
> of problems on these boards for some reason I don't really fathom
> although its still a worthwhile test you did

Hmm.  Memory or motherboard timings.  There are several options in BIOS
about this.  I'll try to experiment.  The only prob - it seems - is that
BIOS only allows INcreasing speeds (frequencies etc), not DEcreasing them.
More, the BIOS does not have CPU frequency control at all - only PCI bus
frequency and memory frequency.  Memory DIMMs are 667 MHz (PC5300), while
the mobo accepts 533MHz (PC4200?), and are running at 533MHz (according to
BIOS).

But in any way, I'll try to experiment here.

> I'd be interested to knowwhat the following do
> 
> Bad RAM check:
> 	Boot with mem= to limit to the bottom 256MB of RAM
> 	(Windows tends to use different areas of RAM to Linux the most so
> 	your report fits that)
> 
> Stress testing:
> 	Go into X in a high resoution, starting running a continuous
> 	copy to or from disk and see if its suddenely much less stable

Okay, running with mem=128m now, copying linux kernel source and
removing it, 10 processes in parallel.

So far, I see the same random SIGSEGVs - not from cp and rm, but from
"usual" suspect - man(1) command segfaults pretty frequently as before ;)

> Disabling power management

Wonder how to disable it... :)  I already turned off all power management
stuff in BIOS I was able to find.

Thanks!

/mjt
