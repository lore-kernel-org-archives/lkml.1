Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZGAA3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZGAA3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbZGAA3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:29:35 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46935 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385AbZGAA3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:29:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat creates multiple files with the same filename
References: <Pine.LNX.4.64.0906281935490.20945@cinke.fazekas.hu>
	<87tz1ylaq8.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0907010158560.835@cinke.fazekas.hu>
Date: Wed, 01 Jul 2009 09:29:34 +0900
In-Reply-To: <Pine.LNX.4.64.0907010158560.835@cinke.fazekas.hu> (Marton
	Balint's message of "Wed, 1 Jul 2009 02:02:53 +0200 (CEST)")
Message-ID: <87y6r9dz4h.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marton Balint <cus@fazekas.hu> writes:

> On Tue, 30 Jun 2009, OGAWA Hirofumi wrote:
>> Marton Balint <cus@fazekas.hu> writes:
>> 
>> > I don't know if removing the invalid characters silently instead of 
>> > returning EINVAL is a good practice, but allowing two files with identical 
>> > filenames is definitely wrong. 
>> 
>> The utf8 function seems didn't return the error for invalid char.
>> 
>> > Could someone please have a look at the problem? Unfortunately I am not 
>> > qualified enough to track it down...
>> >
>> > I've run the testcase on both 2.6.30 and 2.6.31-rc1 kernels, but this bug 
>> > is probably not very new, since I remember having it also in 2.6.27.
>> 
>> This is quick hack though, this should return -EINVAL for invalid char
>> like nls.  Can you try this?
>
> It works for me, filenames with invalid utf-8 characters are now rejected, 
> so I no longer can create multiple files with the same name. Thanks for 
> the fix.

Thanks for testing.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
