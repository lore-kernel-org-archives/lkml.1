Return-Path: <linux-kernel-owner+w=401wt.eu-S934968AbXK3PBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbXK3PBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXK3PA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:00:58 -0500
Received: from rtr.ca ([76.10.145.34]:3030 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbXK3PA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:00:57 -0500
Message-ID: <475025A7.9010107@rtr.ca>
Date: Fri, 30 Nov 2007 10:00:55 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Tejun Heo <htejun@gmail.com>, noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com> <20071130131344.07b75f45@the-village.bc.nu> <20071126075517.GA4141@ucw.cz>
In-Reply-To: <20071126075517.GA4141@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2007-11-30 13:13:44, Alan Cox wrote:
>>> Why does a single spurious interrupt cause it to be shut down?  I can 
>> It doesn't.
>>
>>> see if the interrupt is stuck on and keeps interrupting constantly, but 
>>> if it's just the occasional spurious interrupt, why not just ignore it 
>>> and move on?
>> The interrupt is usually level triggered so it continues to create
>> interrupts until you silence it. The thresholds are about 10,000
>> interrupt events and on newer kernels we also reset the count if we don't
>> see any for a while. That works for most stuff except the thinkpad
>> bluetooth problem.
> 
> Which is confirmed hw problem now, btw.
...

What problem is that, exactly?

My Dell has an internal USB BT adapter that briefly appears
and then disappears again on resume (or stays if I have "enabled" it
via the BIOS key).

I wonder if that has anything to do with the (new in) 2.6.23 pauses
that machine has on resume (about every 10th time).

Cheers
