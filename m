Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZHDVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZHDVBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbZHDVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:01:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:54897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753601AbZHDVBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:01:10 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+4TmtNONK4StMPPD39jc+mo63UAPdgdK8YVLl6ly
	N7r1xENErFH/Lm
Message-ID: <4A78A193.9080805@gmx.de>
Date: Tue, 04 Aug 2009 23:01:07 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/parisc fixes for 2.6.31-rc6
References: <4A75C69E.4060307@gmx.de> <20090804023904.GG28572@bombadil.infradead.org>
In-Reply-To: <20090804023904.GG28572@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 04:39 AM, Kyle McMartin wrote:
> On Sun, Aug 02, 2009 at 07:02:22PM +0200, Helge Deller wrote:
>> Hi Linus,
>>
>> please pull the following changes for the HP parisc architecture.
>>
>> Thanks,
>> Helge
>>
>
> Linus,
>
> Please pull Helge's tree, I'm OK with it now (though I would have
> definitely appreciated *some* notice.)

Kyle,
Thanks a lot!

Helge

>
> regards, Kyle
>
>>
>> The following changes since commit ed680c4ad478d0fee9740f7d029087f181346564:
>>    Linus Torvalds (1):
>>          Linux 2.6.31-rc5
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-2.6.git for-linus
>>
>> Helge Deller (5):
>>        parisc: hp_sdc_mlc.c - check return value of down_trylock()
>>        parisc: dino.c - check return value of pci_assign_resource()
>>        parisc: sticore.c - check return values
>>        parisc: parisc-agp.c - use correct page_mask function
>>        parisc: hppb.c - fix printk format strings
>>
>> Jaswinder Singh Rajput (1):
>>        parisc: includecheck fix for ccio-dma.c
>>
>> John David Anglin (2):
>>        parisc: Fix GOT overflow during module load on 64bit kernel
>>        parisc: Set correct bit in protection flags
>>
>> Michael Buesch (1):
>>        parisc: isa-eeprom - Fix loff_t usage
>>
>> Roel Kluin (1):
>>        parisc: Fix read buffer overflow in pdc_stable driver
>>
>> Stoyan Gaydarov (1):
>>        parisc: fixed faulty check in lba_pci
>>
>>   arch/parisc/kernel/entry.S       |    2 +-
>>   arch/parisc/kernel/module.c      |   50 ++++++++++++++++++++++++++++++++++----
>>   drivers/char/agp/parisc-agp.c    |    2 +-
>>   drivers/input/serio/hp_sdc_mlc.c |    2 +-
>>   drivers/parisc/ccio-dma.c        |    1 -
>>   drivers/parisc/dino.c            |    2 +-
>>   drivers/parisc/eisa_eeprom.c     |    2 +-
>>   drivers/parisc/hppb.c            |    9 ++++--
>>   drivers/parisc/lba_pci.c         |    2 +-
>>   drivers/parisc/pdc_stable.c      |    2 +-
>>   drivers/video/console/sticore.c  |    9 +++++-
>>   11 files changed, 65 insertions(+), 18 deletions(-)
>>
>>
>

