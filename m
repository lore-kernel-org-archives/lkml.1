Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYLCDAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYLCDAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYLCDAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:00:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbYLCDAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:00:19 -0500
Message-ID: <4935F63C.9080207@kernel.org>
Date: Wed, 03 Dec 2008 12:00:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: ST31500341AS vs ICH10, exception Emask 0x50 SAct 0x1 SErr 0x280900
 action 0x6 frozen
References: <1228205289.29251.32.camel@localhost>
In-Reply-To: <1228205289.29251.32.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Dec 2008 03:00:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

Soeren Sonnenburg wrote:
> I just purchased a seagate 1.5TB drive ST31500341AS, with firmware
> revision CC1G (which according to seagate is not affected by the cache
> flush bug) and I am getting the errors below (after almost a day of
> uptime without problems). The drive is replacing a 750G variant from
> seagate with which I had months of uptime and no errors whatsoever.
> 
> I hope anyone has an idea?
> 
> - relevant part of hdparm -I and lspci
> 
> ATA device, with non-removable media
> 	Model Number:       ST31500341AS                            
> 	Firmware Revision:  CC1G    
> 	Transport:          Serial
> 
> 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
> AHCI Controller
> 
> - the error(tm)
> 
> ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
> ata3.00: irq_stat 0x08000000, interface fatal error
> ata3: SError: { UnrecovData HostInt 10B8B BadCRC }

Your machine seems to be suffering genuine link layer problem.  In
most cases, this indicates hardware problem and in my experience
common causes are (in the order of ballpark frequency)...

1. inadequate power supply

2. device and controller don't like each other on 3Gbps

3. cable too long or flaky connector (especially w/ eSATA cables or
   genders or backplanes)

4. faulty controller or drive

-- 
tejun
