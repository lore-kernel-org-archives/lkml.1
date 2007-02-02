Return-Path: <linux-kernel-owner+w=401wt.eu-S1946087AbXBBVNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946087AbXBBVNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946081AbXBBVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:13:39 -0500
Received: from smtp23.orange.fr ([193.252.22.126]:28860 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946087AbXBBVNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:13:38 -0500
X-ME-UUID: 20070202211335710.AD6F67000089@mwinf2322.orange.fr
Message-ID: <45C3A97E.5060909@free.fr>
Date: Fri, 02 Feb 2007 22:13:34 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.7) Gecko/20060405 SeaMonkey/1.0.5
MIME-Version: 1.0
To: Edward Shishkin <edward@namesys.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-list@namesys.com,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc3-mm1: umount reiser4 FS stuck in D state
References: <20070104220200.ae4e9a46.akpm@osdl.org> <200701062158.06329.vs@namesys.com> <45A81231.6040104@free.fr> <200701231940.58053.vs@namesys.com> <20070123154617.GE11995@kernel.dk> <45B65234.4000203@free.fr> <45C247EB.6000806@namesys.com> <45C250C9.3040307@free.fr> <45C26130.5090108@namesys.com>
In-Reply-To: <45C26130.5090108@namesys.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Le 01.02.2007 22:52, Edward Shishkin a écrit :
> Laurent Riffard wrote:
>>
>> Le 01.02.2007 21:04, Edward Shishkin a écrit :
>>>
>>> Laurent, would you please try 2.6.20-rc6-mm3 + this patch:
>>> http://lkml.org/lkml/diff/2007/2/1/195/1
>>
>>
>> Reiser4 works fine with 2.6.20-rc6-mm2 or 2.6.20-rc6-mm3 without any 
>> additional patch (it was broken in rc6-mm1).
>>
>> FWIW, Andrew removed git-block.patch from 2.6.20-rc6-mm2, and he 
>> restored git-block.patch without some problematic CFQ updates in 
>> 2.6.20-rc6-mm3.
>>
>> In this case, does this patch need testing in rc6-mm3 ?
> 
> Yes. This is against git-block patch to prevent endless waiting for IO 
> completion.
> I have reproduced it by ./iozone -B -a -n 524288 -f /mnt/foo
> on x86 box with 512M RAM available.

OK, applied yesterday. I have been using it a few hours with a normal 
workload and I didn't notice any problem.

Thanks
-- 
laurent

