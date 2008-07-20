Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYGTTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYGTTes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYGTTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:34:40 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:45309 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYGTTek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:34:40 -0400
Message-ID: <48839358.8010206@dolphinics.no>
Date: Sun, 20 Jul 2008 21:34:48 +0200
From: Simen Timian Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Simen Thoresen <simentt@dolphinics.no>
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with
 libata
References: <48838593.8020007@dolphinics.no> <20080720194628.6c8632cb@the-village.bc.nu>
In-Reply-To: <20080720194628.6c8632cb@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> [  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM 
>> ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
>> [  155.457103] ata4.00: revalidation failed (errno=-19)
> 
> So it failed because the data read from the drive was corrupted.
> 
>> As I understand, this would most commonly indicate that the drive has 
>> gone bad, but this also occurs on the /other/ drive (same make/model) in 
> 
> Or a cable problem.

Hi Alan,

Should this apply here too? There are two separate cables, and I've 
never seen the other drive to fail after the first drive has failed. 
I've now ripped ~50 CDs with the still working drive, while this drive 
failed during the first 5 CDs on my two previous boots.

I don't doubt that the revalidation goes bad, but I can't see hardware 
being the cause of it as it hits any drive, but so-far only one drive pr 
boot.

-S

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support

