Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXA0WkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXA0WkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbXA0WkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:40:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55414 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbXA0WkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:40:17 -0500
Message-ID: <45BBD4CA.70303@garzik.org>
Date: Sat, 27 Jan 2007 17:40:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux 2.6.20-rc6 - suspend / resume ata_piix
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <1169935901.17469.159.camel@localhost.localdomain>
In-Reply-To: <1169935901.17469.159.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 2007-01-24 at 18:58 -0800, Linus Torvalds wrote:
>> It's been more than a week since -rc5, but I blame everybody (including 
>> me) being away for Linux.conf.au and then me waiting for a few days 
>> afterwards to let everybody sync up.
> 
> ata_piix survives exactly one suspend resume cylce. After resuming the
> second time the disk is not longer usable.
> 
> After the first resume a simple "emacs -nw bla.txt" takes already ~45sec
> to launch, but there are no kernel messages.
> 
> During the second resume the ATA interrupt gets disabled due to an
> unhandled interrupt.
> 
> This is 100% reproducible. So I can provide as much info as needed.

Is this a regression, or behavior that's always been present?

If its a regression, what changeset caused the problem?

	Jeff



