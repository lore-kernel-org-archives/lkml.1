Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbXKLRJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbXKLRJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXKLRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:09:25 -0500
Received: from rtr.ca ([76.10.145.34]:1650 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXKLRJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:09:24 -0500
Message-ID: <473888C2.8070709@rtr.ca>
Date: Mon, 12 Nov 2007 12:09:22 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Laptop's HDD
References: <200711040002.25784.info@gnebu.es> <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
..

The exact same command works with SATA drives.

-ml
