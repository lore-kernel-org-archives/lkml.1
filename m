Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXHBRD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXHBRD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXHBRDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:03:14 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46306 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbXHBRDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:03:13 -0400
Date: Thu, 02 Aug 2007 11:02:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: serial flow control appears broken
In-reply-to: <20070802175711.12bdcaec@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <lkml@rtr.ca>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Message-id: <46B20E12.4020700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
 <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com>
 <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
 <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk>
 <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
 <46B1F0CB.9060106@rtr.ca> <46B202DE.5000709@shaw.ca>
 <20070802175711.12bdcaec@the-village.bc.nu>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I think that PIO transfers only have to be done with interrupts disabled 
>> on really old, evil controllers (without unmask set). I don't think 
>> libata ever disables interrupts during transfers(?)
> 
> Currently libata PIO is mostly done in the IRQ path. Albert Lee was doing
> some work on that but its actually very hard to fix without doing polled
> PIO.

Ah, right. Misread the code.
