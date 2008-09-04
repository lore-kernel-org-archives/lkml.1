Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYIDA24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYIDA24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIDA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:28:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYIDA2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:28:48 -0400
Message-ID: <48BF2BAC.9070508@zytor.com>
Date: Wed, 03 Sep 2008 17:28:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org> <48BED351.1060300@zytor.com> <48BF2AEB.1050508@kernel.org>
In-Reply-To: <48BF2AEB.1050508@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>>
>> (a) we can't do anything about, but (b) we can, by introducing a
>> partition number attribute in sysfs.
> 
> Yeah, that would certainly be a nice addition.  Also, if partitions
> are made proper classes, they'll be easily enumerable by
> /sys/block/*/partitions/*.
> 
> Jens, what do you think?
> 

Note that addition /partitions/ is somewhat unlikely to be useful, since 
existing code will have to search through random crap in sysfs to look 
for the partition directories anyway.

	-hpa
