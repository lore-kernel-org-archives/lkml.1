Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZFCII2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZFCII2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZFCIHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:07:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57567 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbZFCIHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:07:40 -0400
Date: Wed, 3 Jun 2009 10:07:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "damien.wyart@free.fr" <damien.wyart@free.fr>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090603080741.GE11363@kernel.dk>
References: <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com> <20090529155046.GH11363@kernel.dk> <4A20072B.7050807@nokia.com> <20090529170742.GI11363@kernel.dk> <4A2628A7.9080407@nokia.com> <20090603074417.GC11363@kernel.dk> <4A262D6E.9070908@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A262D6E.9070908@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>>> Just to make sure I understood you correctly. I assume my original
>>> patch is fine (because there is bdi_destroy()) and merge it to
>>> ubifs tree.
>>
>> It needs to be:
>>
>>         err = bdi_register(&c->bdi, NULL, "ubifs");
>>         if (err)
>>                 goto out_bdi;
>>
>> so you hit the bdi_destroy() for that failure, not goto out_close;
>> Otherwise it was fine.
>
> Did this, also added a
> Reviewed-by: Jens Axboe <jens.axboe@oracle.com>
>
> http://git.infradead.org/ubifs-2.6.git?a=commit;h=813fdc16ad591e79d0c1b88d31970dcd1c2aa3f1

Looks good!

-- 
Jens Axboe

