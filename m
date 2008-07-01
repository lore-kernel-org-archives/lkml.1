Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYGANQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYGANQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYGANPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:15:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:38055 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbYGANPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:15:36 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for userland
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<20080701122039.GB25580@infradead.org>
Date: Tue, 01 Jul 2008 22:15:30 +0900
In-Reply-To: <20080701122039.GB25580@infradead.org> (Christoph Hellwig's
	message of "Tue, 1 Jul 2008 08:20:40 -0400")
Message-ID: <87vdzpvj7x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>>  #include <linux/magic.h>
>> +#include <asm/byteorder.h>
>
> Why do we need this in the user-visible part of the header?

It was just moved from line below of this.

>> +struct __fat_dirent {
>> +	long		d_ino;
>> +	__kernel_off_t	d_off;
>> +	unsigned short	d_reclen;
>> +	char		d_name[256]; /* We must not include limits.h! */
>> +};
>
> Any reason this is not called fat_dirent? 

It was suggested, and I thought it's safe.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
