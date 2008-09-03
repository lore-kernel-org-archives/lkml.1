Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYICQMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYICQMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYICQMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:12:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYICQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:12:38 -0400
Message-ID: <48BEB759.4050503@zytor.com>
Date: Wed, 03 Sep 2008 09:12:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org>
In-Reply-To: <48BE0EDB.20107@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>>>
>> It would seem better to simply use the high minors on the
>> already-existing ide and scsi majors?
> 
> I thought it would be better to break from those majors to make it clear
> that the traditional minor allocation scheme isn't followed anymore.
> Programs which expect certain majors are likely to need update for how
> it deals with minors, so....
> 

But just allocating a big bucket of device numbers and throw it all into 
a pot semirandomly is likely to cause more damage, not less.

	-hpa
