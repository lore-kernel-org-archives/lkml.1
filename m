Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbXKDAfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbXKDAfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 20:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXKDAez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 20:34:55 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:52140 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbXKDAey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 20:34:54 -0400
Message-ID: <472D13A4.5080906@the-axe-effect.de>
Date: Sun, 04 Nov 2007 01:34:44 +0100
From: Tobias Hoffmann <lk-list@the-axe-effect.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: drive side 80-wire cable detection failed
References: <472CFFBD.2050007@the-axe-effect.de> <20071103232040.33a2fa09@the-village.bc.nu>
In-Reply-To: <20071103232040.33a2fa09@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> On my NV3 board with a Samsung SP1634N Harddisk I wrongly got
>> "drive side 80-wire cable detection failed" with the current kernel.
> 
> Does the drive cable detect correctly on a non Nvidia chipset ?
> 
I have no box here to test this - my laptop won't help.

But I did another test:

I replaced the 80-wire cable with a 40-wire cable. Then the BIOS warns 
about "no 80-wire cable connected". The kernel boot and seems to enable 
UDMA100 which leads to some BadCRC errors. After that the drive is in 
udma3-mode(hdparm) IIRC but not in udma5, as when using the right cable.

Maybe it's not that clever to add the drive to the ivb_list?

As far as I understood it, pata_acpi should fix the problem, but I'm not 
sure on the required configuration. Do I have to disable the normal 
IDE-support? How 'experimental' is the PATA support?


   Tobias
