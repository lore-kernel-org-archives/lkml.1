Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZFOJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZFOJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZFOJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:38:06 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:50334 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZFOJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:38:05 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 05:38:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hgKJ6annKXOmtBapUchzF9jadKKwUY0dkEfEq/uxtgkIqgbQPqfRGJjmIkqyMNb63J
         u7Xg4Kl3/9D9J39m5h6SpQqBcTdcxXvKJ2X+A02mTluXuSdN+NMp5WhJYKJJFHxf2KBx
         QG5bcS9u9DWitLjYH9U240SSxH+/LJCwTdFxs=
Message-ID: <4A3614D1.20403@panasas.com>
Date: Mon, 15 Jun 2009 12:30:57 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>	<20090611110903.GO11363@kernel.dk>	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>	<20090612133014.GK11363@kernel.dk> <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com> <4A35C0A4.20707@ct.jp.nec.com>
In-Reply-To: <4A35C0A4.20707@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2009 06:31 AM, Kiyoshi Ueda wrote:
> Hi Jeff,
> 
> On 06/12/2009 11:33 PM +0900, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>>> On Thu, Jun 11 2009, Jeff Moyer wrote:
>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>> Is blk_rq_unprep_clone really the best name?
>>>>           ^^^^^^
>>> Probably not, but I'm not very good at coming up with elegant names.
>>> Your email should have included a new suggestion :-)
>> Fair enough.  ;)
>>
>>>  - blk_rq_unprep_clone(struct request *clone)
>>>      * Frees cloned bios from the clone request.
>> Why not blk_rq_free_clone?
> 
> Because the 'clone' is not freed in this interface.
> This interface frees only bios in the 'clone'.
> Allocating/freeing the 'clone' are the caller's work, since
> only the caller knows how to allocate/free it.
> 
> 'prep' after 'alloc' and 'unprep' before 'free' is symmetric
> and I feel a good candidate for my request-stacking driver,
> so I chose it. 
> 
> Thanks,
> Kiyoshi Ueda

I'm not a native English speaker as well, so I'm fine
with blk_rq_{prep,unprep}_clone. But maybe the English
people don't like it?

Perhaps
blk_rq_{clone,declone} or blk_rq_{clone,declone}_bios

(Both unclone and declone are found on the net but are not
 found in the free dictionary)

Boaz
