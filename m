Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXJOWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXJOWcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXJOWb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:31:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59274 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXJOWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:31:57 -0400
Message-ID: <4713EA59.30409@garzik.org>
Date: Mon, 15 Oct 2007 18:31:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Kristoffer Nyborg Gregertsen <kngregertsen@norway.atmel.com>
Subject: Re: [git patches] libata update
References: <20071012194002.GA1545@havoc.gtf.org> <200710130342.22217.bzolnier@gmail.com>
In-Reply-To: <200710130342.22217.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Friday 12 October 2007, Jeff Garzik wrote:
>> [ I just sent this upstream to Andrew and Linus ]
>>
>> Now that I have nailed down the corruption problem, I can attend to
>> this...  Fun stuff:
>>
>> * port multiplier support (like an ethernet hub, only dumber)
> 
> Great to see this here.
> 
>> * Asynchronous notification -- finally userspace CD-ROM polling can go away!
> 
> Is this AHCI specific or could be used by some other SATA hosts?

Can be used by any controller that supports SNotification (or is able to 
capture and parse the raw FIS's).

And FWIW, Tejun's PMP work also uses a few bits of same async-notify stuff.

I agree with your review items, and will look at those if others don't 
beat me to it.

	Jeff



