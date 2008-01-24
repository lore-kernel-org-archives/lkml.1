Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYAXOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYAXOyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYAXOyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:54:04 -0500
Received: from xdsl-9553.wroclaw.dialog.net.pl ([84.40.234.81]:49444 "HELO
	mail.alfa-net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755634AbYAXOyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:54:01 -0500
Message-ID: <4798A684.30407@gmail.com>
Date: Thu, 24 Jan 2008 15:53:56 +0100
From: Marcin Gil <marcin.gil@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com> <20080124142717.GA16173@csclub.uwaterloo.ca> <4798A114.6010803@gmail.com> <20080124144359.GD16171@csclub.uwaterloo.ca> <4798A537.9000104@gmail.com> <20080124145132.GE16171@csclub.uwaterloo.ca>
In-Reply-To: <20080124145132.GE16171@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Jan 24, 2008 at 03:48:23PM +0100, Marcin Gil wrote:
>> Yes, this is 80-wire cable; both are connected on the same cable. HDD is 
>> master and DVD is slave. I'll later try disconnecting DVD and see what 
>> happens. I didn't set cable-select due to how these drives are connected
>>
>> +-----+-----+
>> mobo  hdd   dvd
>>
>> I think that cable select would take dvd as master and hdd as slave.
>> This was not preferable when hdd was my primary drive. I can try 
>> cable-select now since I boot off new SATA drive.
> 
> Does the BIOS see the HD on the jmicron when doing disk detection?
> 
> I remember once forgetting to connect power to a driver and spending a
> while wondering why the drive wasn't showing up anywhere.
> 
Yes, both drives are detected by BIOS. Everything is working fine with 
"old" ATA drivers (ide_disk/ide_cd).

IDE HDD Maxtor was my primary disk but I've recently bought new SATA 
disk and was trying to get rid of ATA.

Thank you,
-Marcin Gil

