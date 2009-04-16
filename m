Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZDPNtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZDPNtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZDPNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:49:29 -0400
Received: from rtr.ca ([76.10.145.34]:39172 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDPNt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:49:28 -0400
Message-ID: <49E73766.9090205@rtr.ca>
Date: Thu, 16 Apr 2009 09:49:26 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
References: <20090415014930.GA29413@kroah.com>	<49E5480F.10501@garzik.org>	<20090415050947.GB3462@kroah.com>	<49E5EE41.3090505@rtr.ca>	<20090415073001.503b0361@infradead.org>	<49E5FF48.3030809@rtr.ca>	<20090415125813.34c9a151@infradead.org>	<49E657BC.6000707@rtr.ca>	<20090415183213.7962d929@infradead.org>	<49E6948E.3040901@rtr.ca>	<20090416025408.GE4806@kroah.com>	<20090416115153.68589464@lxorguk.ukuu.org.uk> <20090416063401.32ced22a@infradead.org>
In-Reply-To: <20090416063401.32ced22a@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 16 Apr 2009 11:51:53 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>>> Though it's an onboard USB SSD, not a pluggable stick.
>>> Wow, that's insane.  Leave it to a hardware designer to use a bus
>>> that you never know if you have discovered all the devices to be
>>> the primary device to boot from.
>> Let me see:
>>
>> - Standardised small component
>> - Low pin count and low wire count bus
>> - Cheap
>>
>> In an embedded environment where you know the device is wired in at
>> software level that strikes me not as insane but very sensible.
> 
> I'm not surprised usb is used for storage. What I am surprised at is
> that USB is used in such high end environments that rootwait is not
> sufficient and that the panic-rebooter is needed for the reliability.
..

Failover and redundancy are standard requirements for really reliable systems.
As good as a component may be, there's always anticipation that it will fail
someday, and multiple ways of detecting/overcoming failures must be built-in.

In this case, imagine *two* such SSDs.
