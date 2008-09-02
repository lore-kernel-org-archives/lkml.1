Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYIBUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYIBUSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYIBUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:18:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYIBUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:18:03 -0400
Message-ID: <48BD9F36.8000704@zytor.com>
Date: Tue, 02 Sep 2008 13:16:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org>
In-Reply-To: <48BD3313.7090906@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> Extended devt is scheduled for 2.6.28 merge and is currently using 259.
>> Can extended devt keep this major or should it use something else?
> 
> Oops, I forgot to write information about ext devt.
> 
>  259 block	Block extended device numbers
> 
> 		This is pool of dynamically allocated block device
> 		numbers.  Currently, ide and sd overflows into this
> 		region if there are more partitions than the existing
> 		device number scheme can accomodate, but any block
> 		device can use it and it's not restricted to
> 		overflows.
> 

It would seem better to simply use the high minors on the 
already-existing ide and scsi majors?

	-hpa
