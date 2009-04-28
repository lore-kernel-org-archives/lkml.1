Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZD1C13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZD1C13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZD1C1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:27:20 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:39383 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755831AbZD1C1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:27:19 -0400
Date: Mon, 27 Apr 2009 23:27:11 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: minimizing the configuration of
	linkstation_defconfig
Message-ID: <20090428022711.GA30538@ime.usp.br>
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar.

On Apr 27 2009, Kumar Gala wrote:
>
> On Apr 24, 2009, at 5:33 PM, Rogério Brito wrote:
>> 04. disable CONFIG_BLK_DEV_RAM.
>
> do we not allow booting a ramdisk?

Well, do we need a block device in ram to use initramfs?

(...)
>> Dear Kumar, please, apply this one.
>>
>> I have another patch regarding one regression regarding MTD &
>> PHYSMAP_COMPAT that I plan to send on top of this one.
>
> Ok, can we look at just specifying such info in the linkstation device  
> tree.

Thanks. The MTD & PHYMAP_COMPAT are the things that have been bugging me
and my main reason to keep with the bleeding edge kernels is to get things
whey they were (regarding mtd) as in kernel 2.6.28.

As I have no experience with MTD devices, I would appreciate a reference to
their workings... All that I know is that all my /dev/mtd* devices are gone
if I boot a 2.6.29* kernel.

Of course, I can do a git bisect process (since the MTD subsystem doesn't
work as it did in the past even if I enable PHYMAP_COMPAT and put the same
settings there, quite unfortunately).

> Also, can you break this defconfig update into two patches.  1. that  
> just updates to 2.6.30-rc3 (or latest) and 2. that makes the various  
> changes you've listed above.

No problems with that. I will do that ASAP. Thanks for your kind comments.


Regards, Rogério Brito.

P.S.: Guennadi, did you see any regressions with your linkstation/kurobox
HG or whatever device you have?
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
