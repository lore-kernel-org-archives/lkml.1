Return-Path: <linux-kernel-owner+w=401wt.eu-S965018AbXBTPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbXBTPSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXBTPSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:18:39 -0500
Received: from rtr.ca ([64.26.128.89]:1955 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965018AbXBTPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:18:38 -0500
Message-ID: <45DB114B.4020903@rtr.ca>
Date: Tue, 20 Feb 2007 10:18:35 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: auxsvr@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: ata command timeout
References: <200702192119.50954.auxsvr@gmail.com> <45DA7416.4040101@gmail.com>
In-Reply-To: <45DA7416.4040101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> auxsvr@gmail.com wrote:
..
>>                                                ata1: command timeout
>> Feb 19 20:39:31 linux kernel: ata1: no sense translation for status: 0x40
>> Feb 19 20:39:31 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
>> SK/ASC/ASCQ 0xb/00/00
>> Feb 19 20:39:31 linux kernel: ata1: status=0x40 { DriveReady }
>> Feb 19 20:39:31 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
>> Feb 19 20:39:31 linux kernel: sda: Current: sense key: Aborted Command
>> Feb 19 20:39:31 linux kernel:     Additional sense: No additional sense 
>> information
>> Feb 19 20:39:31 linux kernel: end_request: I/O error, dev sda, sector 89553479
>>
>> without any other ill-effects that I know of(I did smart tests on the drive; 
>> all passed successfully).
>> I have read that hddtemp may be the cause of this (I am running version 0.3) 
>> so is there any reason
>> to worry and prepare for a HDD replacement?
> 
> Not really.  If the problem occurs very infrequently, you don't need to
> worry about it too much.  Command timeouts do occur on otherwise healthy
> systems from time to time.

I don't believe that.  Command timeouts never happen on healthy systems,
unless we have a driver bug.  Okay, so I can imagine a pathological case
of a full queue (NCQ) with all 32 commands taking longer than usual due
to ECC retries in the firmware..

But in real life, on a desktop, timeouts never happen as a normal event.

I wonder what's *really* wrong here?

Cheers

