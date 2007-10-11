Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXJKR5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXJKR5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbXJKR5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:57:01 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45387 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXJKR5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:57:00 -0400
X-Greylist: delayed 1681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 13:57:00 EDT
To: 7eggert@gmx.de
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: Fix printk format strings.
References: <9d2nm-1SV-11@gated-at.bofh.it> <E1Ifvk1-0000o5-VO@be1.lrz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 12 Oct 2007 02:28:52 +0900
In-Reply-To: <E1Ifvk1-0000o5-VO@be1.lrz> (Bodo Eggert's message of "Thu\, 11 Oct 2007 12\:58\:09 +0200")
Message-ID: <87odf5h86j.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>> This makes sure printk format strings contain no more than a single
>> line.
>
>>  printk(KERN_WARNING
>> -                            "FAT: Did not find valid FSINFO signature.\n"
>> +                            "FAT: Did not find valid FSINFO signature.\n");
>> +                     printk(KERN_WARNING
>>  "     Found signature1 0x%08x signature2 0x%08x"
>>  " (sector = %lu)\n",
>
> What about something like
> "Fat32: Invalid FSINFO signatures 0x%08x, 0x%08x; expected 0x%08x, 0x%08\n" ?
> or
> "Fat32: Invalid FSINFO signatures 0x%08x, 0x%08x\n" ?

Looks good to me. I'll modify a patch, and apply it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
