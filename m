Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXKJD2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXKJD2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXKJD2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:28:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53770 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbXKJD2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:28:11 -0500
Message-ID: <47352540.2060104@garzik.org>
Date: Fri, 09 Nov 2007 22:28:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Laptop's HDD
References: <200711040002.25784.info@gnebu.es> <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Sun, 4 Nov 2007, Alberto Gonzalez wrote:
> 
>> The problem comes from a very high rate of load/unload cycles of the heads 
>> that reaches the 300.000-600.000 limit in 2-3 years (with smartmontools it 
>> can checked it with "smartctl -A /dev/sda")  . There are reports of HDD dying 
>> even earlier for this problem [2]
> 
>  I use:
> 
> # hdparm -B 255 /dev/hda
> 
> to get rid of the problem with an ATA disk where I do not care that much 
> about power consumption.  I do not know what the equivalent for a SATA 
> disk would be, but chances are it will be easier to track it down with the 
> reference above.

Although other power management features exist for SATA, for most hdparm 
stuff PATA and SATA are pretty much the same.  Same command set, simply 
a new bus over which to transmit the commands.  A great deal of early 
SATA is actually bridged PATA, even.

	Jeff



