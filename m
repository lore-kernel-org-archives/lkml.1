Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZA3D10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZA3D10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZA3D1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:27:18 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:55998 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZA3D1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:27:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: A B <spinflipper4@yahoo.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com>
	<871vul3g14.fsf@devron.myhome.or.jp> <49822E2A.3020601@zytor.com>
	<957266.96237.qm@web25805.mail.ukl.yahoo.com>
Date: Fri, 30 Jan 2009 12:27:12 +0900
In-Reply-To: <957266.96237.qm@web25805.mail.ukl.yahoo.com> (A. B.'s message of
	"Fri, 30 Jan 2009 00:31:08 +0000 (GMT)")
Message-ID: <87bptp1njj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A B <spinflipper4@yahoo.co.uk> writes:

>> Ok, I've put the patchset to,
>> 
>>     http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz
>> 
>> exfat/series is patch order to apply, and exfat/patches/* is patches.
>> 
>> It would be temporary place, well, anyway, this is my lastest version.
>> 
>
> Thanks for the code, I patched it into 2.6.28.2 and tried it on a 128MB USB
> volume filled with many files. The driver correctly read 73% of the files.
> Impressive. Looking at the others, they seemed to have what I would call
> 'alignment problems'.
>
> md5sum: WARNING: 1008 of 3842 computed checksums did NOT match

Thanks for testing. I see. What is the 'alignment problems'? Well,
anyway, can I get the disk image of USB, or are there any way to
reproduce it in my machine?

Or can you dump with hacked userland command (this can be buggy)?

	http://userweb.kernel.org/~hirofumi/exfat/exfat-userland.tar.gz

$ tar xzf exfat-userland.tar.gz
$ cd exfat-userland
$ make
$ ./exfat /path/to/exfat_device > exfat.dump

And please send exfat.dump.

Well, if you can debug it with this userland command, it would be
helpful. :)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
