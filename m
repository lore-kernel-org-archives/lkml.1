Return-Path: <linux-kernel-owner+w=401wt.eu-S1767101AbXEBVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767101AbXEBVuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767107AbXEBVuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:50:04 -0400
Received: from rtr.ca ([64.26.128.89]:4702 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767101AbXEBVuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:50:00 -0400
Message-ID: <46390781.10507@rtr.ca>
Date: Wed, 02 May 2007 17:49:53 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ioan Ionita <opslynx@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
Subject: Re: More JMicron troubles with 2.6.21
References: <df47b87a0705021037k7dc2d408mcdddbc83daa3b68b@mail.gmail.com> <20070502201511.4c8085e9@the-village.bc.nu>
In-Reply-To: <20070502201511.4c8085e9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I have an Asus Commando Mobo with one of those dreadful JMicron
>> controllers (JMicron 20360/20363 AHCI Controller (rev 02). I have a
> 
> The Jmicron controllers get a lot of testing so should run smoothly.
> 
>> I can't get my CD-RW to work. have tried the pata_jmicron driver and
>> the JMicron  ide driver, no success.
> 
> This is almost certainly a problem outside of the IDE handling in that
> case. The jmicron controllers are smart, there is basically no code to
> the IDE driver to go wrong (especially in the case of using the old IDE
> for the PATA port where you basically use zero code that hasn't been
> tested for years).

The old IDE driver for JMicron didn't work well for me either,
running on Kubuntu Edgy 2.6.17.  It would find the PATA DVD drive,
and work okay for the first half of a DVD movie playback, and then go bonkers.

I eventually gave up on it and installed a pure SATA DVD drive on ICH7(8?)
and just disabled the JMicron completely.

Kernel upgrades are not currenly a viable option for this box
(too many other things would need to be fiddled with).

Cheers
