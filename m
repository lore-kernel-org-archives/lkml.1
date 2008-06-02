Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYFBPD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYFBPD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYFBPDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:03:51 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52754 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYFBPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:03:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Petr Stehlik <pstehlik@sophics.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       =?utf-8?Q?=EF=BF=BD?= <rene.scharfe@lsrfire.ath.cx>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
References: <1211717062.5782.16.camel@ubuntu>
	<87ve12s849.fsf@duaron.myhome.or.jp>
	<20080601221035.GA9107@nineveh.local>
	<87zlq4rd30.fsf@duaron.myhome.or.jp>
	<Pine.LNX.4.64.0806020930170.7351@anakin>
	<4843D179.7070809@sophics.cz>
Date: Tue, 03 Jun 2008 00:03:40 +0900
In-Reply-To: <4843D179.7070809@sophics.cz> (Petr Stehlik's message of "Mon, 02
	Jun 2008 12:54:49 +0200")
Message-ID: <87od6jop4j.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Stehlik <pstehlik@sophics.cz> writes:

> Geert Uytterhoeven wrote:
>>>> Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
>>>> to fix Atari FAT.  I can't speak to whether it works or why it's
>>>> postponed, but it seems to compile.
>>> I see. Although I don't know the patch, I'd like to add this part to
>>> Geert's patch if possible. And when the patch can be posted, we can
>>> re-add this part again.
>>>
>>> Geert, what do you think?
>> 
>> It's in POSTPONED state because nobody speaks up for/against it.
>> Personally, I don't know how much it is (still) needed...
>> But a few years ago somebody contacted me that he used it succesfully
>> on PA-RISC and i386 ;-)
>> 
>> BTW, the patch is
>> http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/POSTPONED/134-atari-fat.diff
>> 
>> Atari people, I think now is the time to let it live or die...
>
> The patch looks good, how can I let it live?

Could you test whether it works well? If it works fine, I'll merge and
clean it up. If it doesn't work, please fix it.

BTW,

+		if (sbi->fat_bits != 32 && total_clusters+2 > sbi->
+			fat_length*SECTOR_SIZE*8/sbi->fat_bits)
+			sbi->fat_bits = 12;

SECTOR_SIZE should be sb->s_blocksize? Or Atari doesn't support the
sector size other than 512 bytes?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
