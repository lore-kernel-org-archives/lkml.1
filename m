Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYG0TdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYG0TdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbYG0TdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:33:08 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:44455 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbYG0TdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:33:07 -0400
Message-ID: <488CCD81.7010002@dolphinics.no>
Date: Sun, 27 Jul 2008 21:33:21 +0200
From: Simen Timian Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with
 libata
References: <48838593.8020007@dolphinics.no> <20080720194628.6c8632cb@the-village.bc.nu> <48839358.8010206@dolphinics.no> <200807202103.51889.alistair@devzero.co.uk>
In-Reply-To: <200807202103.51889.alistair@devzero.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 20 July 2008 20:34:48 Simen Timian Thoresen wrote:
>> Alan Cox wrote:
>>>> [  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM
>>>> ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
>>>> [  155.457103] ata4.00: revalidation failed (errno=-19)
>>> So it failed because the data read from the drive was corrupted.
>>>
>>>> As I understand, this would most commonly indicate that the drive has
>>>> gone bad, but this also occurs on the /other/ drive (same make/model) in
>>> Or a cable problem.
>> Hi Alan,
>>
>> Should this apply here too? There are two separate cables, and I've
>> never seen the other drive to fail after the first drive has failed.
>> I've now ripped ~50 CDs with the still working drive, while this drive
>> failed during the first 5 CDs on my two previous boots.
>>
>> I don't doubt that the revalidation goes bad, but I can't see hardware
>> being the cause of it as it hits any drive, but so-far only one drive pr
>> boot.
> 
> Power supply maybe? Check the rails. The +12VDC must be good.

Hi Alistair, Alan,

I've spent a few hours more looking into this, and I'm not really 
getting much clearer;

I've run either and both of the two DVDroms on an external power-supply 
(drive-power from a jumped, believed good ATX-PSU), and the the symptoms 
remain; inconsistent capabilities reported at boot, and when I start 
ripping CDs, one of them will fail as above.

As I still have the impression that this started when I switched distros 
(ie went from CentOS4 2.6.9 pre-libata-kernel to the current Ubuntu 8.04 
2.6.24-kernel), I've now started playing around with the libata module 
parameters.

Further suggestions are most welcome .-)

Yours,
-S

-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support

