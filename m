Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYABSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYABSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYABSkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:40:10 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:52578 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYABSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:40:08 -0500
Message-ID: <477BDA87.7030702@tlinx.org>
Date: Wed, 02 Jan 2008 10:40:07 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Holger Hoffstaette <holger@wizards.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org> <pan.2008.01.01.01.45.23.430875@wizards.de>
In-Reply-To: <pan.2008.01.01.01.45.23.430875@wizards.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Hoffstaette wrote:
>>     Another new "problem" (not as important) -- even though SATA disks are
>> called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.
>> Devices hda-hdd are not populated in my dev directory on bootup.  Of
>>     
>
> I think this is because the Promise SATA card also has one or more PATA
> channels, so if the card is activated it takes precedence over your old
> controller. But it should only be one channel, not four?
> As for the other problem - I plan on adding such a card to one of my
> systems during the week and might be able to contribute some findings.
>   
---
    FYI - this specific card was sold as "4-SATA" channels.  There were
other contemporary (same package design) Promise cards offered that
were advertised to 1) support 2-sata+2pata or 2) support RAID w/SATA.
I think there was also a RAID card supporting PATA-only as well.

    It is quite possible (though thoroughly 'lame'), that they have 1
card providing, both 4 SATA and 4 PATA, but only provide the connectors
for some subset, with the RAID being a firmware-only (software-only)
option that is implemented in software on the card (as my web searching
indicated was true for some Promise SATA cards). 

    Perhaps an "RFE" for hdparm might be someway to specify the
target device by using a label on one of the devices partitions, since
my boot-time hdparm settings suffer from the same problems my
/etc/fstab used to suffer before "labels" were available.


