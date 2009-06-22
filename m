Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZFVRDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZFVRDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZFVRCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:02:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59966 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZFVRCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:53 -0400
Message-ID: <4A3FB956.6060401@garzik.org>
Date: Mon, 22 Jun 2009 13:03:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: David Miller <davem@davemloft.net>, bzolnier@gmail.com, elendil@planet.nl,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system
 	is dreadfully slow)
References: <20090621.141950.160759111.davem@davemloft.net>	 <200906220034.22430.bzolnier@gmail.com>	 <20090621.155756.100422570.davem@davemloft.net>	 <20090621.161343.181101055.davem@davemloft.net> <87f94c370906212039sa23d49fh305d8f0d58a48d1f@mail.gmail.com>
In-Reply-To: <87f94c370906212039sa23d49fh305d8f0d58a48d1f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
>> I'm going to treat IDE as pure legacy, rather than as competition
>> with the PATA drivers which is what people whould be moving over to.
> 
>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> What impact does that on Linux and its growing popularity in arm
> platforms?  I had assumed that most arm platforms were long term users
> of drivers/ide, but I have no facts to back that up.

libata already has several ARM drivers and does work on that platform in 
general.  A great many platforms are handled by the generic 
pata_platform driver.

There are a handful of IDE drivers not yet ported over to libata, all 
!x86 drivers; maybe there's an odd ARM platform or two in there, I 
haven't checked recently.

If there's a problem or missing functionality, just speak up...

	Jeff




