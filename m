Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYICEPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYICEPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYICEOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:14:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:34308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYICEOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:14:53 -0400
Message-ID: <48BE0EDB.20107@kernel.org>
Date: Wed, 03 Sep 2008 06:13:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com>
In-Reply-To: <48BD9F36.8000704@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 04:14:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>>  259 block    Block extended device numbers
>>
>>         This is pool of dynamically allocated block device
>>         numbers.  Currently, ide and sd overflows into this
>>         region if there are more partitions than the existing
>>         device number scheme can accomodate, but any block
>>         device can use it and it's not restricted to
>>         overflows.
>>
> 
> It would seem better to simply use the high minors on the
> already-existing ide and scsi majors?

I thought it would be better to break from those majors to make it clear
that the traditional minor allocation scheme isn't followed anymore.
Programs which expect certain majors are likely to need update for how
it deals with minors, so....

Thanks.

-- 
tejun
