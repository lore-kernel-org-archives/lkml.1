Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYCFMXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYCFMXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYCFMWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:22:40 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:1467 "EHLO
	scmp07.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754023AbYCFMWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:22:39 -0500
Message-ID: <47CFE1B9.1080405@draigBrady.com>
Date: Thu, 6 Mar 2008 12:21:13 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
 the disk image
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>	 <47CFD6B0.4020602@draigBrady.com> <1204803914.4325.16.camel@frecb07144>
In-Reply-To: <1204803914.4325.16.camel@frecb07144>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2008 12:21:14.0562 (UTC) FILETIME=[92381A20:01C87F84]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXUniqueID: e38cc7ce-2cb5-402a-ac4d-a539dd796384
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Le jeudi 06 mars 2008 à 11:34 +0000, Pádraig Brady a écrit :
>> Laurent Vivier wrote:
>>> This patch allows to use loop device with partitionned disk image.
>>>
>>> Original behavior of loop is not modified.
>>>
>>> A new parameter is introduced to define how many partition we want to be
>>> able to manage per loop device. This parameter is "max_part".
>> I like it!
> 
> Thanks,
> 
>> Shouldn't we set max_part to non zero by default though?
> 
> Well, the problem is that you modify the default minor number of loop
> device if max_part != 0, so I'm afraid of compatibility problems:

I understand that. But who would care about specific minor numbers?
Hmm how does your patch relate to this: http://lwn.net/Articles/110426/

As an aside, I also notice on my system from the following output that
the limit of the number of partitions for a sata/scsi disk seems to be 15:

$ ls -la /dev/sd[ab]
brw-rw---- 1 root disk    8,  0 2007-11-13 10:35 /dev/sda
brw-rw---- 1 root plugdev 8, 16 2008-03-06 12:11 /dev/sdb

Pádraig.
