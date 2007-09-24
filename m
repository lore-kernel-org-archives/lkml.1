Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXIXAOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXIXAOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 20:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXIXAO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 20:14:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44577 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbXIXAO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 20:14:28 -0400
Message-ID: <46F70162.3000108@garzik.org>
Date: Sun, 23 Sep 2007 20:14:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
References: <20070923040437.GA30170@havoc.gtf.org>	 <1190588723.3378.25.camel@localhost.localdomain>	 <46F6FA11.2070501@garzik.org> <1190591947.3378.31.camel@localhost.localdomain>
In-Reply-To: <1190591947.3378.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-09-23 at 19:43 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Sun, 2007-09-23 at 00:04 -0400, Jeff Garzik wrote:
>>>> Rather than sitting on this for far too long, I wanted to go ahead and
>>>> get this out there.  I heard some chips might be trickling out into
>>>> public hands.
>>> The first thing to note is about the specs and the pre-production
>>> hardware: the Linux Foundation has mechanism to get both into the hands
>>> of interested developers; if you can point me to contacts, I can at
>>> least get the NDA documentation programme ball rolling.
>> Well, are there interested, motivated, skilled developers with time?  :)
>>
>> Otherwise it's a moot point.
> 
> We have GregKH's minions ... this would be a good project for them.

> Same answer ... GregKH has a legion ... lets use it.

This is a good project for somebody who knows how SAS behaves on the 
wire, which is a rather limited group.

I'm willing to help anyone who proactively moves in this direction, but 
they need to be proactive about it...  I am the person who will have to 
make introductions at Broadcom, and convince Broadcom that new Person is 
a highly capable SAS software engineer.

Telling bcm "I don't know this guy, its doubtful he knows SAS, but we 
want to make him the primary engineer anyway" is not a very winning tale :)

> SMP and STP, by the way, are simple frame in, frame out.  If it
> identifies the initiator and target protocols and allows us to send
> frames, we can probably transmit both protocols.
[...]
> That's going to be a bit of a bit oops ...
[...]
> well, I suppose it was designed for simple direct connection ...

That's the way it's looking.  There are a few avenues for exposing 
IDENTIFY and OPEN frames and related details, but no obvious "any frame, 
no problem" method like with the Marvell chip.

IMO it's also indicative that Marvell's chip uses a single set of 
command and response queues, whereas Broadcom has command/response 
queues for each "port" (bcm's term).

	Jeff


