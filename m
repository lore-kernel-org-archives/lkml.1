Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZC3LQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZC3LQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZC3LQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:16:09 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:1106 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbZC3LQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:16:08 -0400
Message-ID: <49D0A985.7090307@panasas.com>
Date: Mon, 30 Mar 2009 14:14:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org>
In-Reply-To: <49D08CEC.3010705@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2009 11:16:04.0250 (UTC) FILETIME=[EA2E97A0:01C9B128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2009 12:12 PM, Tejun Heo wrote:
> Borislav Petkov wrote:
>> On Sat, Mar 28, 2009 at 02:51:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
>>
>> [..]
>>
>>>> Bartlomiej, if you're okay with the changes and Jens acks the patches
>>>> and pushing the first three patches via pata-2.6, please feel free to
>>>> include these patches into your tree.
>>> Everything looks fine to me.  Once I get Jens' ack (block bits)
>>> and Borislav's one (ATAPI bits) I'll happily merge this patchset.
>> Yep, I just finished testing the whole series here so you can go ahead
>> and apply them pending a recast of patch 07/14 you'll hopefully be
>> receiving soon from Tejun.
> 
> After the earlier discussion with Boaz Harrosh, I ended up redoing the
> blk_rq_map_{kern|user}_*() stuff and am now in the process of testing
> it.  The patchset is rather large (20+ patches).  As the prealloc
> patch would fit on top of that series, I think it would be better to
> sequence things via git merge.  Is there a git tree I can use for
> pata-2.6 changes?  Or is the current linus master okay?
> 
> Thanks.
> 
> P.S.: Boaz, the above patchset implements blk_rq_map_kern_sgl() 

What is blk_rq_map_kern_sgl() ? I'm not sure I remember ?

What is it's API? and what does it do?

> and
> kills the SCSI layer hack.  That was the issue you were trying to
> solve, right?
> 

If you post URL of git tree I can have a look and start an early review
if you want

Thanks for doing this
Boaz
