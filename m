Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZC3JMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZC3JMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZC3JMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:12:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZC3JMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:12:32 -0400
Message-ID: <49D08CEC.3010705@kernel.org>
Date: Mon, 30 Mar 2009 18:12:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-ide@vger.kernel.org
CC: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic>
In-Reply-To: <20090328140405.GA2741@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 09:12:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Sat, Mar 28, 2009 at 02:51:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> [..]
> 
>>> Bartlomiej, if you're okay with the changes and Jens acks the patches
>>> and pushing the first three patches via pata-2.6, please feel free to
>>> include these patches into your tree.
>> Everything looks fine to me.  Once I get Jens' ack (block bits)
>> and Borislav's one (ATAPI bits) I'll happily merge this patchset.
> 
> Yep, I just finished testing the whole series here so you can go ahead
> and apply them pending a recast of patch 07/14 you'll hopefully be
> receiving soon from Tejun.

After the earlier discussion with Boaz Harrosh, I ended up redoing the
blk_rq_map_{kern|user}_*() stuff and am now in the process of testing
it.  The patchset is rather large (20+ patches).  As the prealloc
patch would fit on top of that series, I think it would be better to
sequence things via git merge.  Is there a git tree I can use for
pata-2.6 changes?  Or is the current linus master okay?

Thanks.

P.S.: Boaz, the above patchset implements blk_rq_map_kern_sgl() and
kills the SCSI layer hack.  That was the issue you were trying to
solve, right?

-- 
tejun
