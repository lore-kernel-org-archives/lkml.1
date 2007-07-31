Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbXGaV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbXGaV4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbXGaVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:55:49 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:41521 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbXGaVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:55:48 -0400
Message-ID: <46AFAF4E.1000605@gmail.com>
Date: Tue, 31 Jul 2007 23:53:18 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: kriko <kristjan.ugrin@gmail.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Reboot hang
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site>
In-Reply-To: <op.twcmvlvcatcbto@linux.site>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2007 11:48 PM, kriko wrote:

>> "Summary screen" will do, but yes, I understood. Perhaps your BIOS 
>> isn't fond of the state the Linux drivers leaves your DVD-ROM at. 
>> Judging by your "nv_pata", you are probebly usiing the pata (pata_amd) 
>> driver, not the old IDE driver?
>>
>> Does it boot through if you disable booting from the DVD-ROM?
> 
> Mentioning the dvd-rom state, it comes to my mind, when rebooting from 
> win, the dvd rom will close tray and  / or LED will blink on reboot.
> None of that happens if I reboot from linux, so it could be a driver 
> problem. I see that I have both (old and new enable in kernel), I don't 
> know which is being used,
> but I'll recompile kernel with just one driver and retest.

Seems a fairly safe assumption that the Linux driver leaves your DVD-ROM in 
a peculiar state then. If you have both drivers compiled in, I believe the 
new PATA driver will "win" (judging by the number of people that lost their 
drives on hda...) so I've added its author to the CC.

Repeating information from your first post:

   Gigabyte gak8nsp (nforce 3)

   NEC DVD-RW@nv_pata
   1x 80 GB WD@nv_sata, 1x 250 GB WD@nv_sata , IBM (20GB) @ nv_pata

Machine hangs at summary screen where it would be trying a boot from DVD 
normally on cold boot, or reboot from Windows. reboot=b doesn't help.

Rene.
