Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbYBBReB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbYBBReB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYBBRdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:33:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33356 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYBBRdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:33:51 -0500
Message-ID: <47A4A96D.2040709@garzik.org>
Date: Sat, 02 Feb 2008 12:33:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu>
In-Reply-To: <20080202170828.GA12748@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> it would have been totally appropriate for me to just send a mail to 
> lkml with the proper subject line about the breakage. (I might even have 
> decided to stay completely silent about the issue and fix it for my own 
> build, letting you guys figure it out.)

Oh come on...   You are smart enough to know to at least CC the driver 
maintainer, the key POC who should be aware of breakage of their driver. 
  That is a standard courtesy.


> ( And as this was spent from my family's weekend time and i had no time
>   and no interest to dig any further than to figure out the "first hop"
>   of the change that broke the build, and the parties who initiated that
>   hop. I'm in fact surprised that your and James's answer to my
>   bugreport is hostility. )

I'm sorry you read "would be nice" as hostility.


> So i find your suggestion that i should have added more people to the 
> Cc: line unfair on several levels.

As I noted, it is an obvious courtesy to CC the driver maintainer, at 
the very least.

_Especially_ when it is a change that requires some knowledge of the 
hardware, as was this case.


>> This set of changes seemed like 50% guesswork to me, without 
>> consulting the authors :( And unlike many changes, you actually have 
>> to know the hardware [or get clues from surrounding code] to make the 
>> change.
> 
> you mean the whole set of changes?

The whole set of changes, yes, not just yours.


> but ... i guess next time i'll think twice before sending any bugreports 
> about or related to the SCSI code anywhere, unless they become really 
> annoying. Who needs this hassle?

The fact is, each larger subsystem (net, scsi, ata I know) has several 
vendor contacts and driver maintainers who for various reasons prefer a 
more focused -- and often less hostile -- mailing list to LKML.

I have a hard enough time as it is, trying to convince hardware vendors 
to work with us, that we are not all assholes.

How about respecting the preferences of certain segments of a very large 
community, even when they differ from your own?  We have a 
community-accepted method of expressing these preferences, the 
MAINTAINERS file.

IMO, standard practice should be:

* To or CC: driver maintainer mentioned in MAINTAINERS (if any)
* CC: LKML, any list mentioned in MAINTAINERS

So, how about CC'ing the targets that have nicely requested to be CC'd?

	Jeff


