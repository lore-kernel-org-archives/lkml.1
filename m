Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbXLGHMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbXLGHMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXLGHMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:12:00 -0500
Received: from echo836.server4you.de ([85.25.140.112]:43948 "EHLO
	mail.pianoinflames.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXLGHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:11:59 -0500
Message-ID: <4758F237.9060201@pianoinflames.de>
Date: Fri, 07 Dec 2007 08:11:51 +0100
From: Marco Gatti <marco@pianoinflames.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
References: <4755BEA1.4090604@pianoinflames.de> <20071206162500.1f76a234.akpm@linux-foundation.org>
In-Reply-To: <20071206162500.1f76a234.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
>> But the effect is under every circumstances described above that I got 
>> after an unspecific time EXT3-fs errors. I tried to use different 
>> partitions, one for root and data, got errors on both.
>>
>> Dec  3 15:05:34 adira EXT3-fs error (device sdb4): ext3_new_block: 
>> Allocating block in system zone - blocks from 74907667, length 1
>>
>> I tried different hard disks, different sizes of partitions, always the 
>> same issue. I always saw that mem is fully cached (I have 8GB RAM!). 
>> After that, the ext3 has severe faults fsck.ext3 repaired them, but an 
>> amount of data was lost.
>>
>> I also tried with different file systems (reiserfs3, xfs), also kernel 
>> trace errors, so I got back to ext3.
>>
>> Can't believe that it's a pure fs-error. Is it an ahci.c issue? Or a 
>> problem with acpi and memory management?
> 
> At a guess I'd say the disk system is being bad.  it might be a hardware
> failure too - it's a new system.
> 

I thought that first, too. I forgot to mention that I did a badblocks on 
the partitions and the two whole disks. No issues reported. I formated 
the disks several times and reinstalled the whole gentoo and compiled 
the kernel again more than one time (I tried 2.6.24-rc3 too) 'cause of 
the ext3 / other fs issues. I did dd if=/dev/zero of=... on the 
partitions and the whole disks. No issues of bad blocks. The strange 
thing is everything works fine under Windows XP x64 Prof. But I don't 
wanted to use that OS really... So I can't believe that's a hardware 
issue of the disks.
