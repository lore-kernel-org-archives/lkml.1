Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYH2Jjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYH2Jjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYH2Jj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:39:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:52031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbYH2Jj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:39:27 -0400
Message-ID: <48B7C361.9070008@kernel.org>
Date: Fri, 29 Aug 2008 11:37:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: linux-next: Tree for August 27
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com> <20080829070515.GL20055@kernel.dk>
In-Reply-To: <20080829070515.GL20055@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 09:38:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
>> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
>> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
>> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
>> in no longer bootable systems (+ help entry for the new option says
>> "Say N if you are unsure.").
>>
>> Tejun/Jens: please consider changing this.
> 
> I have change the default to 'n' for now.

Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
broken?  Did it fail to locate the root partition or were you using
static device nodes?

Thanks.

-- 
tejun
