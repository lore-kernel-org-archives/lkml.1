Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZD1N05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZD1N05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZD1N0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:26:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:41679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbZD1N0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:26:48 -0400
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <F78629F9-59D2-4974-8461-06B7FAC2625D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20090428022711.GA30538@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] powerpc: minimizing the configuration of linkstation_defconfig
Date: Tue, 28 Apr 2009 08:16:34 -0500
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org> <20090428022711.GA30538@ime.usp.br>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27, 2009, at 9:27 PM, Rogério Brito wrote:

> Hi, Kumar.
>
> On Apr 27 2009, Kumar Gala wrote:
>>
>> On Apr 24, 2009, at 5:33 PM, Rogério Brito wrote:
>>> 04. disable CONFIG_BLK_DEV_RAM.
>>
>> do we not allow booting a ramdisk?
>
> Well, do we need a block device in ram to use initramfs?
>
> (...)

I'm pretty sure we need this for old initrd style ramdisks so I'd  
prefer we leave it enabled.

>>> Dear Kumar, please, apply this one.
>>>
>>> I have another patch regarding one regression regarding MTD &
>>> PHYSMAP_COMPAT that I plan to send on top of this one.
>>
>> Ok, can we look at just specifying such info in the linkstation  
>> device
>> tree.
>
> Thanks. The MTD & PHYMAP_COMPAT are the things that have been  
> bugging me
> and my main reason to keep with the bleeding edge kernels is to get  
> things
> whey they were (regarding mtd) as in kernel 2.6.28.
>
> As I have no experience with MTD devices, I would appreciate a  
> reference to
> their workings... All that I know is that all my /dev/mtd* devices  
> are gone
> if I boot a 2.6.29* kernel.
>
> Of course, I can do a git bisect process (since the MTD subsystem  
> doesn't
> work as it did in the past even if I enable PHYMAP_COMPAT and put  
> the same
> settings there, quite unfortunately).

ok.. I killed my kurobox long ago so can't be much help here.

- k