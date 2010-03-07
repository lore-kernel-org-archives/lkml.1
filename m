Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0CGIcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 03:32:36 -0500
Received: from daytona.panasas.com ([67.152.220.89]:32987 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752441Ab0CGIce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 03:32:34 -0500
Message-ID: <4B93649F.10303@panasas.com>
Date: Sun, 07 Mar 2010 10:32:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Subject: Re: [GIT PULL] exofs changes for 2.6.34
References: <4B8FA351.9030000@panasas.com> <20100304140004.GA10838@infradead.org>
In-Reply-To: <20100304140004.GA10838@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2010 08:32:33.0502 (UTC) FILETIME=[BBCBBFE0:01CABDD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 04:00 PM, Christoph Hellwig wrote:
> On Thu, Mar 04, 2010 at 02:10:57PM +0200, Boaz Harrosh wrote:
>>  Next changes will be support for raid5 and raid6
> 
> Err, you're not pushing another bloody copy of raid algorithms in, are
> you?
> 

No of course not. You should know me by now. I intend to fully reuse both
linux/raid/pq.h and linux/async_tx.h.
[What? lose all these CPU/HW optimizations people have done ?-)]

I'm struggling with re-factoring some of drivers/md/raid* as I'm using
bios just as they do, and bio_lists are fine, but currently the code
is very md/dm structure specific, there is no abstract bio_list API
but I hope I can extract one with minimum risk. I have not yet looked
into btrfs, they do raid5 as well right?

But all this is far down the road, off course I'll send RFCs first. The
above push is just for that unique objects groups/striping/mirroring, which
is very small code, a couple of functions actually, over the basic IO.

Thanks for asking, though.
Boaz
